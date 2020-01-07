//
//  AnimatableTableViewVC.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 1/7/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import APExtensions
import BaseClasses
import UIKit

final class AnimatableTableViewVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    @IBOutlet private weak var tableView: AnimatableTableView!
    
    // ******************************* MARK: - Private Properties
    
    private var vm: AnimatableTableViewVM = .init()
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        setup()
        super.viewDidLoad()
    }
    
    private func setup() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerNib(class: AnimatableTableViewCell.self)
        tableView.handleEstimatedSizeAutomatically = true
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // ******************************* MARK: - Actions
    
    @IBAction private func onAddTopTap(_ sender: Any) {
        vm.cellVMs.insert(AnimatableTableViewCellVM(), at: 0)
        tableView.insertFirstRowAndScrollToIt()
    }
    
    @IBAction private func onAddBottomTap(_ sender: Any) {
        vm.cellVMs.append(AnimatableTableViewCellVM())
        tableView.appendRowAndScrollToIt()
    }
    
    @IBAction private func onDeleteTap(_ sender: Any) {
        let random: Int = .random(in: 0..<vm.cellVMs.count)
        let indexPath = IndexPath(row: random, section: 0)
        vm.cellVMs.remove(at: random)
        tableView.deleteRow(indexPath: indexPath)
    }
    
    @IBAction private func onReloadTap(_ sender: Any) {
        let random: Int = .random(in: 0..<vm.cellVMs.count)
        let indexPath = IndexPath(row: random, section: 0)
        vm.cellVMs[indexPath.row].randomize()
        tableView.reloadRow(indexPath: indexPath)
    }
}

// ******************************* MARK: - InstantiatableFromStoryboard

extension AnimatableTableViewVC: InstantiatableFromStoryboard {}

// ******************************* MARK: - UITableViewDelegate, UITableViewDataSource

extension AnimatableTableViewVC: UITableViewDelegate, UITableViewDataSource, AnimatableTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.cellVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AnimatableTableViewCell.self, for: indexPath)
        self.tableView(tableView, configureCell: cell, forRowAt: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, configureCell cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? AnimatableTableViewCell else { return }
        let cellVM = vm.cellVMs[indexPath.row]
        cell.configure(vm: cellVM)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
