//
//  CGFloat+Utils.swift
//  Pods
//
//  Created by Anton Plebanovich on 1/7/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

// ******************************* MARK: - Pixel Comparison

infix operator .== : ComparisonPrecedence
infix operator .!= : ComparisonPrecedence
infix operator .< : ComparisonPrecedence
infix operator .> : ComparisonPrecedence
infix operator .<= : ComparisonPrecedence
infix operator .>= : ComparisonPrecedence
extension CGFloat {
    
    /// Checks whether two `CGFloat` values corresponds to the same pixel.
    static func .== (lhs: CGFloat, rhs: CGFloat) -> Bool {
        let scale = UIScreen.main.scale
        let lhsPixel = (lhs * scale).rounded()
        let rhsPixel = (rhs * scale).rounded()
        return lhsPixel == rhsPixel
    }
    
    /// Checks whether two `CGFloat` values doesn't correspond to the same pixel.
    static func .!= (lhs: CGFloat, rhs: CGFloat) -> Bool {
        return !(lhs .== rhs)
    }
    
    /// Checks whether two `CGFloat` values doesn't correspond to the same pixel and the left one is smaller.
    static func .< (lhs: CGFloat, rhs: CGFloat) -> Bool {
        return lhs .!= rhs && lhs < rhs
    }
    
    /// Checks whether two `CGFloat` values doesn't correspond to the same pixel and the left one is bigger.
    static func .> (lhs: CGFloat, rhs: CGFloat) -> Bool {
        return lhs .!= rhs && lhs > rhs
    }
    
    /// Checks whether two `CGFloat` values corresponds to the same pixel or the left one is smaller.
    static func .<= (lhs: CGFloat, rhs: CGFloat) -> Bool {
        return (lhs .== rhs) || (lhs < rhs)
    }
    
    /// Checks whether two `CGFloat` values corresponds to the same pixel or the left one is bigger.
    static func .>= (lhs: CGFloat, rhs: CGFloat) -> Bool {
        return (lhs .== rhs) || (lhs > rhs)
    }
}

extension CGFloat {
    var _roundedToPixel: CGFloat {
        let scale = UIScreen.main.scale
        return (self * scale).rounded() / scale
    }
}
