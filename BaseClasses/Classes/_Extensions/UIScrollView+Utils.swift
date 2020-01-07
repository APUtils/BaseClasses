//
//  UIScrollView+Utils.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/3/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

extension UIScrollView {
    /// Returns `adjustedContentInset` on iOS >= 11 and `contentInset` on iOS < 11.
    var _fullContentInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        } else {
            return contentInset
        }
    }
    
    var fixedDescription: String {
        let description = super.description.dropLast()
        var descriptionComponents = description.components(separatedBy: "; ")
        
        let fullContentInsets = _fullContentInsets
        if fullContentInsets != .zero {
            let insetsDescription = "{\(fullContentInsets.top._asString), \(fullContentInsets.left._asString), \(fullContentInsets.bottom._asString), \(fullContentInsets.right._asString)}"
            descriptionComponents.append("fullContentInsets = \(insetsDescription)")
        }
        
        if contentOffset == .zero && description.contains("contentOffset") {
            // Remove excessive info
            descriptionComponents.removeAll(where: { $0.contains("contentOffset") })
            
        } else if contentOffset != .zero && !description.contains("contentOffset") {
            // Add info
            let contentOffsetDescription = "{\(contentOffset.x._asString), \(contentOffset.y._asString)}"
            descriptionComponents.append("; contentOffset = \(contentOffsetDescription)")
        }
        
        return descriptionComponents.joined(separator: "; ").appending(">")
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
