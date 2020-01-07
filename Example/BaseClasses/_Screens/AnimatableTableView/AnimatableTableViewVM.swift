//
//  AnimatableTableViewVM.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/7/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation

struct AnimatableTableViewVM {
    
    static let cellsCount: Int = 10
    
    // ******************************* MARK: - Public Properties
    
    var cellVMs: [AnimatableTableViewCellVM]
    
    // ******************************* MARK: - Initialization and Setup
    
    init() {
        self.cellVMs = stride(from: 0, to: AnimatableTableViewVM.cellsCount, by: 1)
            .map { _ in AnimatableTableViewCellVM() }
    }
}
