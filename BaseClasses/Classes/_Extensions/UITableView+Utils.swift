//
//  UITableView+Utils.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/7/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Returns last row index path
    var _lastRowIndexPath: IndexPath {
        let lastSection = numberOfSections - 1
        let lastRow = numberOfRows(inSection: lastSection) - 1
        let lastRowIndexPath = IndexPath(row: lastRow, section: lastSection)
        return lastRowIndexPath
    }
}
