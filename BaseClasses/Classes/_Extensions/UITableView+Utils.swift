//
//  UITableView+Utils.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/7/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Returns first row index path
    var _firstRowIndexPath: IndexPath {
        let firstSection: Int = (min(0, numberOfSections - 1))._clampedRowOrSection
        if firstSection == NSNotFound {
            return IndexPath(row: NSNotFound, section: NSNotFound)
        }
        
        let firstRow = (min(0, numberOfRows(inSection: firstSection) - 1))._clampedRowOrSection
        let firstRowIndexPath = IndexPath(row: firstRow, section: firstSection)
        
        return firstRowIndexPath
    }
    
    /// Returns last row index path
    var _lastRowIndexPath: IndexPath {
        let lastSection: Int = (numberOfSections - 1)._clampedRowOrSection
        if lastSection == NSNotFound {
            return IndexPath(row: NSNotFound, section: NSNotFound)
        }
        
        let lastRow = (numberOfRows(inSection: lastSection) - 1)._clampedRowOrSection
        let lastRowIndexPath = IndexPath(row: lastRow, section: lastSection)
        
        return lastRowIndexPath
    }
}

private extension Int {
    var _clampedRowOrSection: Int {
        if self < 0 {
            return NSNotFound
        } else {
            return self
        }
    }
}
