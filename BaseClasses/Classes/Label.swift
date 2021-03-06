//
//  Label.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/3/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
@available(iOSApplicationExtension 9.0, *)
open class Label: UILabel {
    
    private enum Constants {
        static let pulseTransitionKey = "pulseTransitionKey"
    }
    
    override open var text: String? {
        set {
            guard super.text != newValue else { return }
            
            // Just set text if not animated
            guard UIView.inheritedAnimationDuration > 0 else {
                super.text = newValue
                return
            }
            
            layer.setValue(UUID(), forKey: Constants.pulseTransitionKey)
            
            super.text = newValue
        }
        
        get {
            return super.text
        }
    }
    
    override open var attributedText: NSAttributedString? {
        set {
            guard super.attributedText != newValue else { return }
            
            // Just set text if not animated
            guard UIView.inheritedAnimationDuration > 0 else {
                super.attributedText = newValue
                return
            }
            
            layer.setValue(newValue, forKey: Constants.pulseTransitionKey)
            super.attributedText = newValue
        }
        
        get {
            return super.attributedText
        }
    }
    
    override open func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == Constants.pulseTransitionKey {
            // Get animation attributes to create proper animations
            if let action = self.action(for: layer, forKey: "backgroundColor") as? CAAnimation {
                
                let halfDisappearDuration = action.duration * 0.1
                
                // Disappear using opacity
                let disappearAnimation = CABasicAnimation(keyPath: "opacity")
                disappearAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
                disappearAnimation.toValue = 0
                disappearAnimation.duration = action.duration / 2 - halfDisappearDuration
                disappearAnimation.fillMode = .forwards
                
                // Animate from current state to current state to allow text to disappear but meanwhile frame will animate to a new value.
                let image = _getSnapshotImage()?.cgImage
                let keepCurrentStateAnimation = CABasicAnimation(keyPath: "contents")
                keepCurrentStateAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
                keepCurrentStateAnimation.fromValue = image
                keepCurrentStateAnimation.toValue = image
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
    func _getSnapshotImage() -> UIImage? {
        if #available(iOS 10.0, tvOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
            
        } else {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
            defer { UIGraphicsEndImageContext() }
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            self.layer.render(in: context)
            guard let snapshotImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            return snapshotImage
        }
    }
}
