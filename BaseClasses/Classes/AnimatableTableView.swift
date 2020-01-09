//
//  AnimatableTableView.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/7/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

open class AnimatableTableView: TableView {
    
//    open override var contentOffset: CGPoint {
//        didSet {
//            print("contentOffset: \(contentOffset.y)")
//        }
//    }
//    
//    open override var contentSize: CGSize {
//        didSet {
//            print("contentSize: \(contentSize.height)")
//        }
//    }
    
    // ******************************* MARK: - Initialization and Setup
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        
    }
    
    // ******************************* MARK: - Animations
    
    open func reloadRow(indexPath: IndexPath) {
        guard let dataSource = dataSource as? AnimatableTableViewDataSource else {
            print("AnimatableTableView: dataSource is missing or doesn't conform to `AnimatableTableViewDataSource`")
            return
        }
        
        guard let cell = cellForRow(at: indexPath), cell._isVisibleInWindow else { return super.reloadRows(at: [indexPath], with: .none) }
        
        // We reload cell manually and trigger table view cells height reload
        // so we can animate cell content changes.
        UIView.animate(withDuration: 0.3) {
            dataSource.tableView(self, configureCell: cell, forRowAt: indexPath)
            self.beginUpdates()
            self.endUpdates()
        }
    }
    
    open func deleteRow(indexPath: IndexPath) {
        guard let cell = cellForRow(at: indexPath), cell._isVisibleInWindow else { return super.deleteRows(at: [indexPath], with: .none) }
        super.deleteRows(at: [indexPath], with: .fade)
    }
    
    open func insertFirstRowAndScrollToIt() {
        // Several things happening here.
        // 1) .none - is a row animation. Table view still has expand animation with .insertRows call
        // 2) When table scrolled to the top, a new cell just expands from the top but
        // even when a new cell should appear under a transparent bar it first jump content offset to a new position and then
        // animates expand. It does it until first cell is far away from the screen so insertion is just broken for that case.
        // 3) On iOS 12.4 it behaves differenlty from iOS 13.3
        // 4) We might be scrolling
        
        // To cover all cases we completelly disable animations,
        // insert, fix content offset and then animate fade in manually.
        // After everything we scroll to top.
        
        // Stop active scrolling
        setContentOffset(contentOffset, animated: false)
        
        let canAnimate = contentOffset.y <= -_fullContentInsets.top
        let firstRowIndexPath = IndexPath(row: 0, section: 0)
        var insertedCell: UITableViewCell?
        UIView.performWithoutAnimation {
            let originalContentOffset = contentOffset
            
            // As a fallback to restore offset
            let topCell = visibleCells.first
            let topCellOriginalOffset = topCell?.frame.minY
            
            // Insert cell
            insertRows(at: [firstRowIndexPath], with: .none)
            layoutIfNeeded()
            
            // Checking if it was added
            if let _insertedCell = cellForRow(at: firstRowIndexPath) {
                insertedCell = _insertedCell
                
                // Prepare fade in animation
                _insertedCell.alpha = 0
                
                // Fixing content offset
                let animationStartContentOffsetY = (originalContentOffset.y + _insertedCell.frame.size.height)._roundedToPixel
                let animationStartContentOffset = CGPoint(x: contentOffset.x, y: animationStartContentOffsetY)
                setContentOffset(animationStartContentOffset, animated: false)
                layoutIfNeeded()
                    
                if animationStartContentOffsetY .!= contentOffset.y {
                    assertionFailure("Offset was changed during layout")
                }
                
            } else if let topCell = topCell, let topCellOriginalOffset = topCellOriginalOffset {
                if canAnimate {
                    assertionFailure("Inserted cell is missing, thought, it was assuming possible to be animated.")
                }
                
                let contentOffsetFix = topCell.frame.minY - topCellOriginalOffset
                let animationStartContentOffsetY = (originalContentOffset.y + contentOffsetFix)._roundedToPixel
                let animationStartContentOffset = CGPoint(x: contentOffset.x, y: animationStartContentOffsetY)
                setContentOffset(animationStartContentOffset, animated: false)
                layoutIfNeeded()
                
                if contentOffset.y .!= animationStartContentOffsetY {
                    assertionFailure("Offset was changed during layout")
                }
                
            } else {
                assertionFailure("Unable to restore top offset")
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            insertedCell?.alpha = 1
        }
        
        _scrollToTop(animated: true)
    }
    
    open func appendRowAndScrollToIt() {
        // Table view adds cell without animations at the bottom if it outside of visible bounds
        // So need to animate it manually.
        
        // Stop active scrolling
        setContentOffset(contentOffset, animated: false)
        
        // TODO: Animate manually always
        let sectionsCount = dataSource?.numberOfSections?(in: self) ?? 0
        guard let rowsCount = dataSource?.tableView(self, numberOfRowsInSection: sectionsCount) else { return }
        let lastRowIndexPath = IndexPath(row: rowsCount - 1, section: sectionsCount)
        
        let canAnimate = _visibleFrame.maxY .>= _contentFrame.maxY
        if canAnimate {
            if _visibleFrame.maxY .> _contentFrame.maxY {
                // Cell will be loaded and animated
                insertRows(at: [lastRowIndexPath], with: .fade)
                
            } else {
                UIView.performWithoutAnimation {
                    // Notify table view about new cell and prepare it for a fade in animation.
                    insertRows(at: [lastRowIndexPath], with: .none)
                    if let cell = cellForRow(at: lastRowIndexPath) {
                        // In some cases it might be loaded.
                        cell.alpha = 0
                        
                    } else {
                        // In some cases it might not be loaded.
                        // Make added cell visible so it'll be loaded.
                        // Sadly, we need to do it twice.
                        contentOffset.y += 1
                        layoutIfNeeded()
                        contentOffset.y += 1
                        cellForRow(at: lastRowIndexPath)?.alpha = 0
                    }
                }
                
                // Fade in
                UIView.animate(withDuration: 0.3) {
                    self.cellForRow(at: lastRowIndexPath)?.alpha = 1
                }
            }
            
        } else {
            insertRows(at: [lastRowIndexPath], with: .none)
        }
        
        _scrollToBottom(animated: true)
    }
}

public protocol AnimatableTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, configureCell cell: UITableViewCell, forRowAt indexPath: IndexPath)
}
