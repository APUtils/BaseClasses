//
//  SelfResizableTextView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 9/20/17.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Text view with zero paddings between text and frame and self sizable depending on content.
open class SelfResizableTextView: TextView {
    
    // ******************************* MARK: - Public properties
    
    override open var contentSize: CGSize {
        get {
            return super.contentSize
        }
        set {
            super.contentSize = newValue
            didSetContentSize()
        }
    }
    
    /// Closure that called on `contentSize` change
    open var onContentSizeDidChange: ((CGSize) -> Void)?
    
    // ******************************* MARK: - Private Properties
    
    private var previousContentSize = CGSize.zero
    
    // ******************************* MARK: - Initialization and Setup
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setup() {
        setupProperties()
    }
    
    private func setupProperties() {
        isScrollEnabled = true
    }
    
    // ******************************* MARK: - UIView Overrides
    
    override open var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    // ******************************* MARK: - Private Methods - didSet/willSet
    
    private func didSetContentSize() {
        // Do not refresh if contentSize is the same
        guard previousContentSize != contentSize else { return }
        
        previousContentSize = contentSize
        invalidateIntrinsicContentSize()
        onContentSizeDidChange?(contentSize)
    }
}
