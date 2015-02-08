//
//  Carousel1ViewController.swift
//  Carousel
//
//  Created by Jiro Nagashima on 2/8/15.
//  Copyright (c) 2015 Ookami, Inc. All rights reserved.
//

import UIKit

class CarouselViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet weak var carousel : iCarousel!
    private var items: [Int] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        for i in 0...9 {
            items.append(i)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        carousel.type = .Wheel
        carousel.decelerationRate = 0.8
    }

    // MARK: - Private

    private func expandCurrentItemView() {
        let currentItemView = carousel.currentItemView

        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            let transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
            currentItemView.transform = CGAffineTransformTranslate(transform, 0, -20)
        }, completion: nil)
    }

    private func collapseCurrentItemView() {
        let currentItemView = carousel.currentItemView

        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            currentItemView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)
        }, completion: nil)
    }

    // MARK: - iCarouselDataSource

    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return items.count
    }

    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView! {
        var label: UILabel! = nil

        //create new view if no view is available for recycling
        if (view == nil) {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            view = UIView(frame:CGRectMake(0, 0, 180, 240))
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)
            view.contentMode = .Center
            view.backgroundColor = UIColor.lightGrayColor()
            view.layer.borderColor = UIColor.blackColor().CGColor
            view.layer.borderWidth = 1

            label = UILabel(frame:view.bounds)
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

    // MARK: - iCarouselDelegate

    func carouselWillBeginDragging(carousel: iCarousel!) {
        collapseCurrentItemView()
    }

    func carouselDidEndDragging(carousel: iCarousel!, willDecelerate decelerate: Bool) {
        if !decelerate {
            expandCurrentItemView()
        }
    }

    func carouselDidEndDecelerating(carousel: iCarousel!) {
        expandCurrentItemView()
    }

    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .Wrap:
            return 0
        case .Spacing:
            return value * 0.85
        case .Arc:
            return value * 0.5
        default:
            return value
        }
    }
}
