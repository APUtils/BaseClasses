//
//  UIScrollView+Utils.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/3/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

public extension UIScrollView {
    /// Returns `adjustedContentInset` on iOS >= 11 and `contentInset` on iOS < 11.
    private var _fullContentInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        } else {
            return contentInset
        }
    }
    
    /// Fixed `UIScrollView` description. Includes info about insets and doesn't include trash info.
    var fixedDescription: String {
        var descriptionComponents: [String] = []
        
        // Class
        let typeDescription = NSStringFromClass(type(of: self))
        let pointerDescription = Unmanaged<AnyObject>.passUnretained(self).toOpaque().debugDescription
        let classDescription = "\(typeDescription): \(pointerDescription)"
        descriptionComponents.append(classDescription)
        
        // Frame
        let frameDescription = "(\(frame.minX._asString) \(frame.minY._asString); \(frame.maxX._asString) \(frame.maxY._asString))"
        descriptionComponents.append("frame = \(frameDescription)")
        
        // Insets
        let fullContentInsets = _fullContentInsets
        if fullContentInsets != .zero {
            let insetsDescription = "{\(fullContentInsets.top._asString), \(fullContentInsets.left._asString), \(fullContentInsets.bottom._asString), \(fullContentInsets.right._asString)}"
            descriptionComponents.append("fullContentInsets = \(insetsDescription)")
        }
        
        // Content Size
        let contentSizeDescription = "(\(contentSize.width._asString), \(contentSize.height._asString))"
        descriptionComponents.append("; contentSize = \(contentSizeDescription)")
        
        // Offset
        if contentOffset != .zero {
            // Add info
            let contentOffsetDescription = "{\(contentOffset.x._asString), \(contentOffset.y._asString)}"
            descriptionComponents.append("; contentOffset = \(contentOffsetDescription)")
        }
        
        return "<\(descriptionComponents.joined(separator: "; "))>"
    }
}

private extension FloatingPoint {
    /// Checks if `self` is whole number.
    var _isWhole: Bool {
        return truncatingRemainder(dividingBy: 1) == 0
    }
}

private extension CGFloat {
    var _asString: String {
        if _isWhole {
            return "\(Int(self))"
        } else {
            return String(format: "%.1f", self)
        }
    }
}
