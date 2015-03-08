//
//  PageViewController.swift
//  Paging
//
//  Created by Jiro Nagashima on 3/8/15.
//  Copyright (c) 2015 Ookami, Inc. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Page"

        pageViewController.dataSource = self
        pageViewController.delegate = self

        let contentViewController = ContentViewController()
        contentViewController.index = 0
        pageViewController.setViewControllers([contentViewController], direction: .Forward, animated: false, completion: nil)

        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.frame = view.bounds
        pageViewController.didMoveToParentViewController(self)

        view.gestureRecognizers = pageViewController.gestureRecognizers
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = ContentViewController()
        contentViewController.index = 0

        return contentViewController
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = ContentViewController()
        contentViewController.index = 0

        return contentViewController
    }
}
