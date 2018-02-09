//
//  EndGameScene.swift
//  kidGameSprite
//
//  Created by STEVE DURAN on 12/16/17.
//  Copyright © 2017 STEVE DURAN. All rights reserved.
//

import UIKit
import SpriteKit

class EndGameScene: SKScene{
    //var score: Int = 0
    
    //var scoreLabel: SKLabelNode!
    var startGameButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        startGameButton = SKSpriteNode(imageNamed: "newGameButton")
        startGameButton.position = CGPoint(x: 30 ,y: 50)
        addChild(startGameButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameButton" {
                if let view = self.view {
                    
                    if let endScene = SKScene(fileNamed: "MenuScene") {
                        endScene.scaleMode = .aspectFill
                        
                        //present the screen
                        view.presentScene(endScene)
                    }
                    
                    view.ignoresSiblingOrder = true
                    view.showsFPS = false
                    view.showsNodeCount = false
                }
            }
            }
        }
    }
