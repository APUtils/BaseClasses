//
//  MainVC.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/3/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import APExtensions
import UIKit

final class MainVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        setup()
        super.viewDidLoad()
    }
    
    private func setup() {
        
    }
    
    // ******************************* MARK: - UIViewController Overrides
    
    // ******************************* MARK: - Actions
    
    @IBAction private func onAnimatableTablveViewTap(_ sender: Any) {
        let vc = AnimatableTableViewVC.instantiateFromStoryboard()
        navigationController?.pushViewController(vc)
    }
    
    // ******************************* MARK: - Notifications
}

// ******************************* MARK: - InstantiatableFromStoryboard

extension MainVC: InstantiatableFromStoryboard {
}
