//
//  AnimatableTableViewCellVM.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/7/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import APExtensions
import UIKit

private var maxStringLength: Int { .random(in: 0...200) }

struct AnimatableTableViewCellVM {
    
    // ******************************* MARK: - Public Properties
    
    var backgroundColor: UIColor = .init(hex: .random(in: 0...0xFFFFFF))
    var text: String = .random(length: maxStringLength)
    
    mutating func randomize() {
        backgroundColor = .init(hex: .random(in: 0...0xFFFFFF))
        text = .random(length: maxStringLength)
    }
    
}

// ******************************* MARK: - Random

private extension String {
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789            "
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
