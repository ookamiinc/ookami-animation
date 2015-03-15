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

    private var idleTimer: NSTimer?
    private let idleDuration = 3.0

    private var boundaryTimeObserver: AnyObject?
    private var sceneIndex: Int = 0 {
        didSet(oldSceneIndex) {
            if sceneIndex != oldSceneIndex {
                delegate?.playerViewController(self, sceneIndexDidChange: sceneIndex)
            }
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

        updateSceneIndex()

        addBoundaryTimeObserver()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        removeBoundaryTimeObserver()
    }

    // MARK: - Public

    func seekToPreviousScene() {
        if isFirstScene() {
            return
        }

        removeBoundaryTimeObserver()

        let previousBoundaryTime = CMTimeMakeWithSeconds(boundaryTimes[--sceneIndex], Int32(NSEC_PER_SEC))
        player.seekToTime(previousBoundaryTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        player.play()

        addBoundaryTimeObserver()
    }

    func seekToNextScene() {
        if isLastScene() {
            return
        }

        removeBoundaryTimeObserver()

        let nextBoundaryTime = CMTimeMakeWithSeconds(boundaryTimes[++sceneIndex], Int32(NSEC_PER_SEC))
        player.seekToTime(nextBoundaryTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        player.play()

        addBoundaryTimeObserver()
    }

    // MARK: - Private

    internal func idle() {
        player.pause()
    }

    internal func resumeFromIdle() {
        player.play()
        updateSceneIndex()
    }

    private func addBoundaryTimeObserver() {
        let slicedBoundaryTimes = sceneIndex + 1 < boundaryTimes.count ? Array(boundaryTimes[(sceneIndex + 1)..<boundaryTimes.count]) : [Double]()
        boundaryTimeObserver = player.addBoundaryTimeObserverForTimes(slicedBoundaryTimes, queue: nil) {
            self.idle()
            self.idleTimer = NSTimer.scheduledTimerWithTimeInterval(self.idleDuration, target: self, selector: "resumeFromIdle", userInfo: nil, repeats: false)
        }
    }

    private func removeBoundaryTimeObserver() {
        player.removeTimeObserver(boundaryTimeObserver)
        idleTimer?.invalidate()
    }

    private func updateSceneIndex() {
        let currentTime = round(CMTimeGetSeconds(player.currentTime()))
        if let sceneIndex = find(boundaryTimes, currentTime) {
            self.sceneIndex = sceneIndex
        }
    }

    private func isFirstScene() -> Bool {
        return sceneIndex == 0
    }

    private func isLastScene() -> Bool {
        return sceneIndex == boundaryTimes.count - 1
    }
}
