//
//  PageViewController.swift
//  Paging
//
//  Created by Jiro Nagashima on 3/8/15.
//  Copyright (c) 2015 Ookami, Inc. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {

    let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Page"

        automaticallyAdjustsScrollViewInsets = false

        pageViewController.dataSource = self
        pageViewController.delegate = self

        let contentViewController = ContentViewController()
        contentViewController.index = 0
        pageViewController.setViewControllers([contentViewController], direction: .Forward, animated: false, completion: nil)

        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)

        view.gestureRecognizers = pageViewController.gestureRecognizers

        if let scrollView = pageViewController.view.subviews.first as? UIScrollView {
            scrollView.delegate = self
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pageViewController.view.frame = view.bounds
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

    // MARK: - Scroll View Delegate

    func scrollViewDidScroll(scrollView: UIScrollView) {
        println(scrollView.contentOffset)
    }
}
