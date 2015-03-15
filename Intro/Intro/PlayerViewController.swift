//
//  PlayerViewController.swift
//  Intro
//
//  Created by Jiro Nagashima on 3/15/15.
//  Copyright (c) 2015 Jiro Nagashima. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol PlayerViewControllerDelegate: class {
    func playerViewController(viewController: PlayerViewController, sceneIndexDidChange sceneIndex: Int)
}

class PlayerViewController: AVPlayerViewController {

    weak var delegate: PlayerViewControllerDelegate?

    private let boundaryTimes = [0.0, 3.0, 6.0]

    private var boundaryTimeObserver: AnyObject?
    private var sceneIndex: Int = 0 {
        didSet {
            delegate?.playerViewController(self, sceneIndexDidChange: sceneIndex)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var URL = NSBundle.mainBundle().URLForResource("video", withExtension: "mp4")
        player = AVPlayer.playerWithURL(URL) as AVPlayer

        videoGravity = AVLayerVideoGravityResizeAspectFill
        view.userInteractionEnabled = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        boundaryTimeObserver = player.addBoundaryTimeObserverForTimes(boundaryTimes, queue: nil) {
            let currentTime = round(CMTimeGetSeconds(self.player.currentTime()))
            if let sceneIndex = find(self.boundaryTimes, currentTime) {
                self.sceneIndex = sceneIndex
            }
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        player.removeTimeObserver(boundaryTimeObserver)
    }

    // MARK: - Public

    func seekToPreviousScene() {
        let isFirstScene = (sceneIndex == 0)
        if isFirstScene {
            return
        }

        let previousBoundaryTime = CMTimeMakeWithSeconds(boundaryTimes[--sceneIndex], Int32(NSEC_PER_SEC))
        player.seekToTime(previousBoundaryTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        player.play()
    }

    func seekToNextScene() {
        let isLastScene = (sceneIndex == boundaryTimes.count - 1)
        if isLastScene {
            return
        }

        let nextBoundaryTime = CMTimeMakeWithSeconds(boundaryTimes[++sceneIndex], Int32(NSEC_PER_SEC))
        player.seekToTime(nextBoundaryTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        player.play()
    }
}
