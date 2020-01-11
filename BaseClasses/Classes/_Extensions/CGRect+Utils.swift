//
//  CGRect+Utils.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/11/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

extension CGRect {
    
    /// Returns new rect rounded to a nearest pixel.
    var _roundedToPixel: CGRect {
        return CGRect(x: origin.x._roundedToPixel,
                      y: origin.y._roundedToPixel,
                      width: size.width._roundedToPixel,
                      height: size.height._roundedToPixel)
    }
}
