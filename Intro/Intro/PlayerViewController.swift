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
    func playerViewController(viewController: PlayerViewController, indexDidChange index: Int)
}

class PlayerViewController: AVPlayerViewController {

    weak var delegate: PlayerViewControllerDelegate?
    private let boundaryTimes = [0.0, 3.0, 6.0]

    override func viewDidLoad() {
        super.viewDidLoad()

        var URL = NSBundle.mainBundle().URLForResource("video", withExtension: "mp4")
        player = AVPlayer.playerWithURL(URL) as AVPlayer
        
        player.addBoundaryTimeObserverForTimes(boundaryTimes, queue: nil) {
            let currentTime = round(CMTimeGetSeconds(self.player.currentTime()))
            if let index = find(self.boundaryTimes, currentTime) {
                self.delegate?.playerViewController(self, indexDidChange: index)
            }
        }

        videoGravity = AVLayerVideoGravityResizeAspectFill
        view.userInteractionEnabled = false
    }
}
