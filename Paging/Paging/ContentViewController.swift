//
//  ContentViewController.swift
//  Paging
//
//  Created by Jiro Nagashima on 2/22/15.
//  Copyright (c) 2015 Ookami, Inc. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    private let label = UILabel()
    
    var index: Int? {
        didSet {
            if let index = index {
                label.text = String(index)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        label.frame = view.bounds
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        label.font = label.font.fontWithSize(50)
        label.tag = 1
        view.addSubview(label)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let index = index {
            println("viewWillAppear: \(index)")
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let index = index {
            println("viewDidAppear: \(index)")
        }
    }
}
