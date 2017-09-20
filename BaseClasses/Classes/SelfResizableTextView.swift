//
//  SelfResizableTextView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 9/20/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Text view with zero paddings between text and frame and self sizable depending on content.
open class SelfResizableTextView: TextView {
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization and Setup
    //-----------------------------------------------------------------------------
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        textContainer.heightTracksTextView = true
    }
}
