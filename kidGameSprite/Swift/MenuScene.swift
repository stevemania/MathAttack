//
//  MenuScene.swift
//  kidGameSprite
//
//  Created by STEVE DURAN on 12/16/17.
//  Copyright © 2017 STEVE DURAN. All rights reserved.
//

import UIKit
import SpriteKit
class MenuScene: SKScene {
        
        var startGameButton: SKSpriteNode!
        
        override func didMove(to view: SKView) {
            
            startGameButton = SKSpriteNode(imageNamed: "newGameButton")
            startGameButton.position = CGPoint()
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            let touch = touches.first
            
            if let location = touch?.location(in: self){
                let nodesArray = self.nodes(at: location)
                
                if nodesArray.first?.name == "newGameButton" {
                    let transition = SKTransition.flipVertical(withDuration: 1.5)
                    let gameScene =  GameScene(size:CGSize(width: 1242, height: 2208))
                    self.view?.presentScene(gameScene, transition: transition)
                }
            }

    }
}
