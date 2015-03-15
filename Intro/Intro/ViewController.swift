//
//  ViewController.swift
//  Intro
//
//  Created by Jiro Nagashima on 3/15/15.
//  Copyright (c) 2015 Jiro Nagashima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PlayerViewControllerDelegate {

    @IBOutlet private weak var pageControl: UIPageControl!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let playerViewController = segue.destinationViewController as? PlayerViewController {
            playerViewController.delegate = self
        }
    }

    // MARK: - PlayerViewControllerDelegate

    func playerViewController(viewController: PlayerViewController, indexDidChange index: Int) {
        pageControl.currentPage = index
    }
}

