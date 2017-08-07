//
//  TableViewCellExampleViewController.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 8/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import APExtensions


final class TableViewCellExampleViewController: UIViewController {}

//-----------------------------------------------------------------------------
// MARK: - UITableViewDelegate, UITableViewDataSource
//-----------------------------------------------------------------------------

extension TableViewCellExampleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: indexPath.row % 2 == 0 ? "Cell" : "TableViewCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
