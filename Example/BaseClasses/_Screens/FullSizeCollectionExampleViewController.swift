//
//  FullSizeCollectionExampleViewController.swift
//  BaseClasses
//
//  Created by Anton Plebanovich on 8/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import BaseClasses
import StretchScrollView


class FullSizeCollectionExampleViewController: UIViewController {

    // ******************************* MARK: - @IBOutlets
    
    @IBOutlet private weak var scrollView: StretchScrollView?
    @IBOutlet private weak var pageControl: UIPageControl!
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print(scrollView?.fixedDescription ?? "")
    }
    
    private func setup() {
        scrollView?.addFadeViews([pageControl])
    }
}

// ******************************* MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension FullSizeCollectionExampleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if let imageView = cell.contentView.subviews.first as? UIImageView {
            imageView.image = UIImage(named: "\(indexPath.row + 1)")!
        }
        
        return cell
    }
}

// ******************************* MARK: - UIScrollViewDelegate

extension FullSizeCollectionExampleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        pageControl.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
    }
}
