//
//  ScreenSideRelativeConstraint.swift
//  Elevate
//
//  Created by Anton Plebanovich on 1/15/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Constraint that constant evaluated at a runtime.
/// If constraint is width relative then screen's width is multiplied
/// by multiplier and value is set into constraint's constant field.
/// If constraint is height relative then screen's height is multiplied
/// by multiplier and value is set into constraint's constant field.
public final class ScreenSideRelativeConstraint: NSLayoutConstraint {
    
    // ******************************* MARK: - @IBInspectable
    
    /// Wheter this constraint width relative.
    @IBInspectable var isWidthRelative: Bool = true
    
    /// Wheter this constraint width relative.
    @IBInspectable override public var multiplier: CGFloat {
        get {
            return _multiplier
        }
        set {
            _multiplier = newValue
        }
    }
    
    // ******************************* MARK: - NSLayoutConstraint Properties Overrides
    
    override public var constant: CGFloat {
        get {
            if isSetupDone {
                return super.constant
            } else {
                return relativeConstant
            }
        }
        set {
            super.constant = newValue
        }
    }
    
    // ******************************* MARK: - Private Properties
    
    private var _multiplier: CGFloat = 1
    private var isSetupDone = false
    
    private var relativeConstant: CGFloat {
        return _multiplier * (isWidthRelative ? UIScreen.main.bounds.width : UIScreen.main.bounds.height)
    }
    
    // ******************************* MARK: - Initialization and Setup
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        super.constant = _multiplier * (isWidthRelative ? UIScreen.main.bounds.width : UIScreen.main.bounds.height)
        isSetupDone = true
    }
}
