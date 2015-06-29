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

    private var isAppearanceTransitioning = false

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

        let initialContentViewController = dequeueReusableContentViewControllerAtIndex(0)
        initialContentViewController.index = 0
        insertContentViewController(initialContentViewController, atIndex: 0)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let currentContentViewController = contentViewControllerMapTable.objectForKey(carousel.currentItemIndex) as? ContentViewController
        currentContentViewController?.beginAppearanceTransition(true, animated: animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let currentContentViewController = contentViewControllerMapTable.objectForKey(carousel.currentItemIndex) as? ContentViewController
        currentContentViewController?.endAppearanceTransition()
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
            if !contains(carousel.indexesForVisibleItems as! [Int], index) {
                if let contentViewController = contentViewControllerMapTable.objectForKey(index) as? ContentViewController {
                    contentViewController.removeFromParentViewController()
                }
            }
        }
    }

    private func sourceIndexAndDestinationIndex() -> (Int, Int) {
        let isDirectionLeftToRight = carousel.scrollOffset - round(carousel.scrollOffset) > 0

        var sourceIndex = isDirectionLeftToRight ? Int(floor(carousel.scrollOffset)) : Int(ceil(carousel.scrollOffset))
        var destinationIndex = isDirectionLeftToRight ? Int(ceil(carousel.scrollOffset)) : Int(floor(carousel.scrollOffset))

        sourceIndex = sourceIndex < carousel.numberOfItems ? sourceIndex : 0
        destinationIndex = destinationIndex < carousel.numberOfItems ? destinationIndex : 0

        return (sourceIndex, destinationIndex)
    }

    private func beginAppearanceTransitions(isAppearing: Bool, sourceIndex: Int, destinationIndex: Int) {
        let sourceContentViewController = contentViewControllerMapTable.objectForKey(sourceIndex) as? ContentViewController
        let destinationContentViewController = contentViewControllerMapTable.objectForKey(destinationIndex) as? ContentViewController

        sourceContentViewController?.beginAppearanceTransition(!isAppearing, animated: false)
        destinationContentViewController?.beginAppearanceTransition(isAppearing, animated: false)
    }

    // MARK: - iCarouselDataSource

    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        return items.count
    }

    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        let view = UIView(frame: carousel.bounds)

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

    func carouselWillBeginDragging(carousel: iCarousel!) {
        isAppearanceTransitioning = false
    }

    
    func carouselDidScroll(carousel: iCarousel!) {
        if !isAppearanceTransitioning {
            let (sourceIndex, destinationIndex) = sourceIndexAndDestinationIndex()
            beginAppearanceTransitions(true, sourceIndex: sourceIndex, destinationIndex: destinationIndex)
        }

        isAppearanceTransitioning = true
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
