//
//  UIScrollView+Utils.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/3/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

// ******************************* MARK: - Description

public extension UIScrollView {
    
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
        descriptionComponents.append("contentSize = \(contentSizeDescription)")
        
        // Offset
        if contentOffset != .zero {
            // Add info
            let contentOffsetDescription = "{\(contentOffset.x._asString), \(contentOffset.y._asString)}"
            descriptionComponents.append("contentOffset = \(contentOffsetDescription)")
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

// ******************************* MARK: - Insets

extension UIScrollView {
    /// Returns `adjustedContentInset` on iOS >= 11 and `contentInset` on iOS < 11.
    var _fullContentInsets: UIEdgeInsets {
        if #available(iOS 11.0, *, tvOS 11.0, *) {
            return adjustedContentInset
        } else {
            return contentInset
        }
    }
}

// ******************************* MARK: - Scroll

extension UIScrollView {
    func _scrollToTop(animated: Bool) {
        if let tableView = self as? UITableView {
            // Since table view `contentSize` might change when cell become visible
            // we need to use `UITableView`'s methods instead.
            let indexPath = tableView._firstRowIndexPath
            tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
            
        } else {
            let topContentOffset: CGPoint = .init(x: 0, y: -_fullContentInsets.top)
            if animated {
                setContentOffset(topContentOffset, animated: true)
            } else {
                contentOffset = topContentOffset
            }
        }
    }
    
    func _scrollToBottom(animated: Bool) {
        func _getBottomContentOffset() -> CGPoint {
            let height = bounds.size.height
            var y: CGFloat = _fullContentInsets.bottom
            if contentSize.height > height {
                y += contentSize.height - height
            }
            
            let minOffsetY = -_fullContentInsets.top
            let maxOffsetY = max(contentSize.height - bounds.size.height + _fullContentInsets.bottom, -_fullContentInsets.top)
            y = min(y, maxOffsetY)
            y = max(y, minOffsetY)
            
            return CGPoint(x: 0, y: y)
        }
        
        if let tableView = self as? UITableView {
            // Since table view `contentSize` might change when cell become visible
            // we need to use `UITableView`'s methods instead.
            let lastRowIndexPath = tableView._lastRowIndexPath
            tableView.scrollToRow(at: lastRowIndexPath, at: .bottom, animated: animated)
            
        } else {
            // Use `UIScrollView`'s methods
            let bottomContentOffset = _getBottomContentOffset()
            if animated {
                setContentOffset(bottomContentOffset, animated: true)
            } else {
                contentOffset = bottomContentOffset
            }
        }
    }
}

// ******************************* MARK: - Helper Properties

public extension UIScrollView {
    
    /// Frame of the content.
    var _contentFrame: CGRect {
        CGRect(x: 0,
               y: 0,
               width: contentSize.width,
               height: contentSize.height)
            ._roundedToPixel
    }
    
    /// Scrollable frame. Equal to content size + fullContentInsets.
    var _scrollableFrame: CGRect {
        CGRect(x: -_fullContentInsets.left,
               y: -_fullContentInsets.top,
               width: contentSize.width + _fullContentInsets.right + _fullContentInsets.left,
               height: contentSize.height + _fullContentInsets.bottom + _fullContentInsets.top)
            ._roundedToPixel
    }
    
    /// Visible area frame. Equal to bounds.
    var _visibleFrame: CGRect { bounds._roundedToPixel }
    
    /// Returns whether scrollable frame is more than visible frame
    var _isScrollable: Bool {
        return _scrollableFrame.height .> _visibleFrame.height
    }
}
