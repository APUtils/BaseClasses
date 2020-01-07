//
//  AnimatableTableView.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/7/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit

open class AnimatableTableView: TableView {
    
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
        
        // To fix above we first check if we can insert animated and do default flow.
        // And if we can't we completelly disable animations, insert and then animate fade in manually.
        // After everything we scroll to top.
        let canAnimate = contentOffset.y <= -_fullContentInsets.top
        let firstRowIndexPath = IndexPath(row: 0, section: 0)
        if canAnimate {
            self.insertRows(at: [firstRowIndexPath], with: .fade)
        } else {
            UIView.performWithoutAnimation {
                insertRows(at: [firstRowIndexPath], with: .none)
                cellForRow(at: firstRowIndexPath)?.alpha = 0
            }
            
            UIView.animate(withDuration: 0.3) {
                self.cellForRow(at: firstRowIndexPath)?.alpha = 1
            }
        }
        
        _scrollToTop(animated: true)
    }
    
    open func appendRowAndScrollToIt() {
        let sectionsCount = dataSource?.numberOfSections?(in: self) ?? 0
        guard let rowsCount = dataSource?.tableView(self, numberOfRowsInSection: sectionsCount) else { return }
        let lastRowIndexPath = IndexPath(row: rowsCount - 1, section: sectionsCount)
        
        let isVisible = _visibleFrame.maxY .>= _contentFrame.maxY
        if isVisible {
            insertRows(at: [lastRowIndexPath], with: .fade)
        } else {
            insertRows(at: [lastRowIndexPath], with: .none)
        }
        
        _scrollToBottom(animated: true)
    }
}

public protocol AnimatableTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, configureCell cell: UITableViewCell, forRowAt indexPath: IndexPath)
}
