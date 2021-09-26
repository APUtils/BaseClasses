//
//  Label.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/3/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

#if COCOAPODS
import LogsManager
#else
import RoutableLogger
#endif

@available(iOS 9.0, *)
@available(iOSApplicationExtension 9.0, *)
open class Label: UILabel {
    
    private enum Constants {
        static let pulseTransitionKey = "pulseTransitionKey"
    }
    
    // ******************************* MARK: - Initialization and Setup
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        currentBounds = bounds
    }
    
    // ******************************* MARK: - Animation
    
    private static var warnEmited = false
    
    private var capturingSnapshotImage = false
    private var snapshotImage: UIImage?
    private var currentBounds: CGRect = .zero
    
    override open var text: String? {
        set {
            guard super.text != newValue else { return }
            
            // Animate if needed.
            if UIView.inheritedAnimationDuration > 0 {
                // TODO: Routable logger
                if !Self.warnEmited && (newValue == nil || newValue == "") {
                    RoutableLogger.logWarning("WARNING ONCE: It is not recommended to assign `nil` or `\"\"` value for a `text` because fade in or fade out animation won't work. Please use `\" \"` instead.")
                    Self.warnEmited = true
                }
                
                // We need to capture image as soon as possible because
                // bounds might change before we can prepare animation.
                if layer.animation(forKey: Constants.pulseTransitionKey) == nil {
                    captureSnapshotImageInCurrentBounds()
                }
                
                layer.setValue(UUID(), forKey: Constants.pulseTransitionKey)
            }
            
            super.text = newValue
        }
        
        get {
            return super.text
        }
    }
    
    override open var attributedText: NSAttributedString? {
        set {
            guard super.attributedText != newValue else { return }
            
            if UIView.inheritedAnimationDuration > 0 {
                // We need to capture image as soon as possible because
                // bounds might change before we can prepare animation.
                if layer.animation(forKey: Constants.pulseTransitionKey) == nil {
                    captureSnapshotImageInCurrentBounds()
                }
                
                layer.setValue(newValue, forKey: Constants.pulseTransitionKey)
            }
            
            super.attributedText = newValue
        }
        
        get {
            return super.attributedText
        }
    }
    
    open override var bounds: CGRect {
        set {
            let newSize = newValue.size
            let previousSize = currentBounds.size
            
            // TODO: Animate width change because there is still a possibility of text placement change without height change.
            
            // Animate number of lines change if needed.
            // Default animation is bad and we need to sustain consistency with other labels animation.
            let heightChange = newSize.height - previousSize.height
            if UIView.inheritedAnimationDuration > 0,
               numberOfLines != 1,
               abs(heightChange) >= font.pointSize / 2 {
                
                // We need to capture image as soon as possible because
                // bounds might change before we can prepare animation.
                if layer.animation(forKey: Constants.pulseTransitionKey) == nil {
                    snapshotImage = _getSnapshotImage(bounds: currentBounds)
                }
                
                layer.setValue(UUID(), forKey: Constants.pulseTransitionKey)
                
            } else if capturingSnapshotImage {
                // It is possible that bounds set will be called more than once
                // but we need to capture only the first snapshot.
                let snapshotImage = _getSnapshotImage(bounds: currentBounds)
                if self.snapshotImage == nil {
                    self.snapshotImage = snapshotImage
                }
            }
            
            self.currentBounds = newValue
            
            super.bounds = newValue
        }
        
        get {
            return super.bounds
        }
    }
    
    private func captureSnapshotImageInCurrentBounds() {
        // It's possible that bounds will change during snapshot capture
        // so we need to capture snapshot before change is occured in `bounds`.
        capturingSnapshotImage = true
        layer.layoutIfNeeded()
        capturingSnapshotImage = false
        
        if snapshotImage == nil {
            snapshotImage = _getSnapshotImage(bounds: currentBounds)
        }
    }
    
    override open func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == Constants.pulseTransitionKey {
            
            // Do not update animation if there is already ongoing
            if layer.animation(forKey: event) != nil {
                return super.action(for: layer, forKey: event)
            }
            
            // Get animation attributes to create proper animations
            if let action = super.action(for: layer, forKey: "backgroundColor") as? CAAnimation {
                
                let halfDisappearDuration = action.duration * 0.1
                
                // Disappear using opacity
                let disappearAnimation = CABasicAnimation(keyPath: "opacity")
                disappearAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
                disappearAnimation.toValue = 0
                disappearAnimation.duration = action.duration / 2 - halfDisappearDuration
                disappearAnimation.fillMode = .forwards
                
                // Animate from current state to current state to allow text to disappear but meanwhile frame will animate to a new value.
                let keepCurrentStateAnimation = CABasicAnimation(keyPath: "contents")
                keepCurrentStateAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
                
                // Use previously captured image or capture new right now
                let snapshotImage = self.snapshotImage?.cgImage ?? _getSnapshotImage(bounds: bounds)?.cgImage
                self.snapshotImage = nil
                
                keepCurrentStateAnimation.fromValue = snapshotImage
                keepCurrentStateAnimation.toValue = snapshotImage
                keepCurrentStateAnimation.duration = action.duration / 2
                
                // Appear using opacity
                let appearAnimation = CABasicAnimation(keyPath: "opacity")
                appearAnimation.fromValue = 0
                appearAnimation.toValue = 1
                appearAnimation.beginTime = action.duration / 2 + halfDisappearDuration
                appearAnimation.duration = action.duration / 2 - halfDisappearDuration
                
                let animationGroup = CAAnimationGroup()
                animationGroup.animations = [disappearAnimation, keepCurrentStateAnimation, appearAnimation ]
                animationGroup.autoreverses = action.autoreverses
                animationGroup.beginTime = action.beginTime
                animationGroup.delegate = action.delegate
                animationGroup.duration = action.duration
                animationGroup.fillMode = action.fillMode
                animationGroup.isRemovedOnCompletion = action.isRemovedOnCompletion
                animationGroup.repeatCount = action.repeatCount
                animationGroup.repeatDuration = action.repeatDuration
                animationGroup.speed = action.speed
                animationGroup.timeOffset = action.timeOffset
                animationGroup.timingFunction = action.timingFunction
                
                return animationGroup
            }
        }
        
        return super.action(for: layer, forKey: event)
    }
}

public extension UIView {
    /// Creates image from view and adds overlay image at the center if provided
    func _getSnapshotImage(bounds: CGRect) -> UIImage? {
        if #available(iOS 10.0, tvOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
            
        } else {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
            defer { UIGraphicsEndImageContext() }
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            layer.render(in: context)
            guard let snapshotImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            return snapshotImage
        }
    }
}
