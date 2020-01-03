//
//  UIScrollView+Utils.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/3/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

extension UIScrollView {
    var fixedDescription: String {
        let contentInsetDescription = "{\(contentInset.top._asString), \(contentInset.left._asString), \(contentInset.bottom._asString), \(contentInset.right._asString)}"
        var description = super.description.dropLast().appending("; contentInset = \(contentInsetDescription)>")
        if !description.contains("contentOffset") {
            let contentOffsetDescription = "{\(contentOffset.x._asString), \(contentOffset.y._asString)}"
            description = description.dropLast().appending("; contentOffset = \(contentOffsetDescription)>")
        }
        
        return description
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
