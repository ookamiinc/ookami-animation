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

class PlayerViewController: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var URL = NSBundle.mainBundle().URLForResource("video", withExtension: "mp4")
        player = AVPlayer.playerWithURL(URL) as AVPlayer

        videoGravity = AVLayerVideoGravityResizeAspectFill
        
        view.userInteractionEnabled = false
    }
}
