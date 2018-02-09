//
//  GameViewController.swift
//  kidGameSprite
//
//  Created by STEVE DURAN on 11/28/17.
//  Copyright © 2017 STEVE DURAN. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreGraphics

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* let scene = GameScene(size:CGSize(width: 1242, height: 2208))
        //let scene = GameScene(size:CGSize(width: 1242, height: 2208))
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        */
       
         if let view = self.view as! SKView? {
            
            if let scene = SKScene(fileNamed: "MenuScene") {
                scene.scaleMode = .aspectFill
                
                //present the screen
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
