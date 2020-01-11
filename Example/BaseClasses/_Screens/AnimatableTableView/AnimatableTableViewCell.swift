//
//  AnimatableTableViewCell.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/7/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import APExtensions
import BaseClasses
import UIKit

final class AnimatableTableViewCell: TableViewCell, InstantiatableFromXib {
    
    // ******************************* MARK: - @IBOutlets
    
    @IBOutlet private var label: UILabel!
    
    // ******************************* MARK: - Configuration
    
    func configure(vm: AnimatableTableViewCellVM) {
        label.text = vm.text
        contentView.backgroundColor = vm.backgroundColor
    }
}
