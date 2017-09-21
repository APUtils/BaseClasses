//
//  LabelLikeTextView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 9/21/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


/// Text view that acts like UILabel (self sizing, can not be edit or scroll),
/// but has various detections (address, links, etc) that UITextView has.
/// Also process clicks on links.
class LabelLikeTextView: SelfResizableTextView {
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization and Setup
    //-----------------------------------------------------------------------------
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        isSelectable = true
        isEditable = false
        dataDetectorTypes = [.all]
    }
}
