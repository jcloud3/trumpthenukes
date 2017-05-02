//
//  GameViewController.swift
//  Trump the Nukes
//
//  Created by jcloud on 4/18/17.
//  Copyright © 2017 Cloudy. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
   
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        let scene = StartScreen(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
