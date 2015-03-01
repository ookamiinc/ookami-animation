//
//  CaroucelViewController.swift
//  Paging
//
//  Created by Jiro Nagashima on 2/15/15.
//  Copyright (c) 2015 Ookami, Inc. All rights reserved.
//

import UIKit

class CarouselViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet weak var carousel : iCarousel!

    private var items = [Int]()
    private var contentViewControllerMapTable = NSMapTable.strongToWeakObjectsMapTable()

    override func awakeFromNib() {
        super.awakeFromNib()

        for i in 0...9 {
            items.append(i)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "iCarousel"

        // just like UIScrollView
        carousel.type = .Linear
        carousel.decelerationRate = 0.6
        carousel.scrollSpeed = 1.7
    }

    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return false
    }

    // MARK: - Private

    private func dequeueReusableContentViewControllerAtIndex(index: Int) -> ContentViewController {
        if let contentViewController = contentViewControllerMapTable.objectForKey(index) as? ContentViewController {
            return contentViewController
        } else {
            return ContentViewController()
        }
    }

    private func insertContentViewController(contentViewController: ContentViewController, atIndex index: Int) {
        addChildViewController(contentViewController)
        contentViewControllerMapTable.setObject(contentViewController, forKey: index)
    }

    private func removeInvisibleContentViewControllers() {
        let keyEnumerator = contentViewControllerMapTable.keyEnumerator()
        while let index: Int = keyEnumerator.nextObject() as? Int {
            if !contains(carousel.indexesForVisibleItems as [Int], index) {
                if let contentViewController = contentViewControllerMapTable.objectForKey(index) as? ContentViewController {
                    contentViewController.removeFromParentViewController()
                }
            }
        }
    }

    // MARK: - iCarouselDataSource

    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return items.count
    }

    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView! {
        view = UIView(frame: carousel.bounds)

        let contentViewController = dequeueReusableContentViewControllerAtIndex(index)
        contentViewController.index = items[index]

        insertContentViewController(contentViewController, atIndex: index)

        contentViewController.willMoveToParentViewController(self)
        view.addSubview(contentViewController.view)
        contentViewController.didMoveToParentViewController(self)

        return view
    }

    // MARK: - iCarouselDelegate

    func carouselCurrentItemIndexDidChange(carousel: iCarousel!) {
        removeInvisibleContentViewControllers()
    }

    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .Wrap:
            return 1
        default:
            return value
        }
    }
}
