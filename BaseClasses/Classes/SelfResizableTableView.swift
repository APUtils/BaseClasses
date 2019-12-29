//
//  SelfResizableTableView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 9/14/17.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import UIKit


open class SelfResizableTableView: TableView {
    
    // ******************************* MARK: - UIView Overrides
    
    open override var contentSize: CGSize {
        didSet {
            guard oldValue != contentSize else { return }
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var contentInset: UIEdgeInsets {
        didSet {
            guard oldValue != contentInset else { return }
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = contentSize
        intrinsicContentSize.height += contentInset.top
        intrinsicContentSize.height += contentInset.bottom
        intrinsicContentSize.width += contentInset.left
        intrinsicContentSize.width += contentInset.right
        
        return intrinsicContentSize
    }
    
    // ******************************* MARK: - Initialization and Setup
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    private func setup() {
        isScrollEnabled = false
        bounces = false
        alwaysBounceVertical = false
        alwaysBounceHorizontal = false
    }
}
