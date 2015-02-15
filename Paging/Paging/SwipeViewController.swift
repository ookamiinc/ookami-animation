//
//  SwipeViewController.swift
//  Paging
//
//  Created by Jiro Nagashima on 2/15/15.
//  Copyright (c) 2015 Ookami, Inc. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController, SwipeViewDataSource, SwipeViewDelegate {

    @IBOutlet weak var swipeView : SwipeView!

    override func viewDidLoad() {
        super.viewDidLoad()

        swipeView.wrapEnabled = true
    }

    // MARK: - SwipeViewDatasource

    func numberOfItemsInSwipeView(swipeView: SwipeView!) -> Int {
        return 5
    }

    func swipeView(swipeView: SwipeView!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        let itemView = UIView(frame: swipeView.bounds)
        itemView.autoresizingMask = .FlexibleWidth | .FlexibleHeight

        let label = UILabel(frame: itemView.bounds);
        label.text = "\(index)"
        label.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        label.font = label.font.fontWithSize(50)
        label.tag = 1
        itemView.addSubview(label)
        
        return itemView;
    }

    // MARK: - SwipeViewDelegate

    func swipeViewItemSize(swipeView: SwipeView!) -> CGSize {
        return swipeView.bounds.size
    }
}
