//
//  TextView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 9/20/17.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Text view with zero paddings between text and frame
open class TextView: UITextView {
    
    // ******************************* MARK: - IBInspectable
    
    @IBInspectable open var textSideInset: CGFloat = 0 {
        didSet {
            configureInsets()
        }
    }
    
    @IBInspectable open var placeholder: String? {
        didSet {
            if placeholder == oldValue { return }
            updatePlaceholder()
        }
    }
    
    // ******************************* MARK: - Lazy
    
    open private(set) lazy var placeholderLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)
        l.isHidden = !text.isEmpty
        
        return l
    }()
    
    open override var text: String! {
        get { super.text }
        set {
            guard super.text != newValue else { return }
            super.text = newValue
            updatePlaceholderVisibility()
        }
    }
    
    // ******************************* MARK: - Initialization and Setup
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
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
        textContainer.lineFragmentPadding = 0
        NotificationCenter.default.addObserver(self, selector: #selector(onTextChange), name: UITextView.textDidChangeNotification, object: self)
        
        configure()
    }
    
    // ******************************* MARK: - Configuration
    
    private func configure() {
        configureInsets()
    }
    
    private func configureInsets() {
        let insets = UIEdgeInsets(top: 0, left: textSideInset, bottom: 0, right: textSideInset)
        textContainerInset = insets
    }
    
    // ******************************* MARK: - Update
    
    private func updatePlaceholder() {
        addSubview(placeholderLabel)
        
        placeholderLabel.text = placeholder
        if let pointSize = font?.pointSize {
            placeholderLabel.font = .italicSystemFont(ofSize: pointSize)
            placeholderLabel.sizeToFit()
            placeholderLabel.frame.origin = .zero
        }
        
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        guard placeholder != nil else { return }
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    // ******************************* MARK: - Notifications
    
    @objc fileprivate func onTextChange(_ sender: Any) {
        updatePlaceholderVisibility()
    }
}
