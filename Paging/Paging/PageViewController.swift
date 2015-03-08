//
//  PageViewController.swift
//  Paging
//
//  Created by Jiro Nagashima on 3/8/15.
//  Copyright (c) 2015 Ookami, Inc. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {

    private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    private var indexes = [Int]()

    override func awakeFromNib() {
        super.awakeFromNib()

        for i in 0...9 {
            indexes.append(i)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Page"

        automaticallyAdjustsScrollViewInsets = false

        pageViewController.dataSource = self
        pageViewController.delegate = self

        let contentViewController = ContentViewController()
        contentViewController.index = indexes.first

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

        if let viewController = viewController as? ContentViewController {
            if let index = viewController.index {
                contentViewController.index = index != 0 ? index - 1 : indexes.last
            }
        }

        return contentViewController
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = ContentViewController()

        if let viewController = viewController as? ContentViewController {
            if let index = viewController.index {
                contentViewController.index = index != indexes.last ? index + 1 : indexes.first
            }
        }

        return contentViewController
    }

    // MARK: - Scroll View Delegate

    func scrollViewDidScroll(scrollView: UIScrollView) {
        // println(scrollView.contentOffset)
    }
}
