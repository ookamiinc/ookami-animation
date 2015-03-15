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

    private weak var playerViewController: PlayerViewController? {
        didSet {
            if let playerViewController = playerViewController {
                playerViewController.delegate = self
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let playerViewController = segue.destinationViewController as? PlayerViewController {
            self.playerViewController = playerViewController
        }
    }

    // MARK: - IBActions

    @IBAction func swipeToLeft(sender: UISwipeGestureRecognizer) {
        playerViewController?.seekToNextScene()
    }

    @IBAction func swipeToRight(sender: UISwipeGestureRecognizer) {
        playerViewController?.seekToPreviousScene()
    }

    // MARK: - PlayerViewControllerDelegate

    func playerViewController(viewController: PlayerViewController, sceneIndexDidChange sceneIndex: Int) {
        pageControl.currentPage = sceneIndex
    }
}

