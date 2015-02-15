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
    private var items: [Int] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        for i in 0...9 {
            items.append(i)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SwipeView"

        swipeView.wrapEnabled = true
    }

    // MARK: - SwipeViewDatasource

    func numberOfItemsInSwipeView(swipeView: SwipeView!) -> Int {
        return items.count
    }

    func swipeView(swipeView: SwipeView!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView! {
        var label: UILabel! = nil

        //create new view if no view is available for recycling
        if (view == nil) {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            view = UIView(frame: swipeView.bounds)

            label = UILabel(frame: view.bounds)
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Center
            label.font = label.font.fontWithSize(50)
            label.tag = 1
            view.addSubview(label)
        } else {
            //get a reference to the label in the recycled view
            label = view.viewWithTag(1) as UILabel!
        }

        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        label.text = "\(items[index])"

        return view
    }

    // MARK: - SwipeViewDelegate

    func swipeViewItemSize(swipeView: SwipeView!) -> CGSize {
        return swipeView.bounds.size
    }
}
