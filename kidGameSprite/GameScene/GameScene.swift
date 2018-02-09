//
//  GameScene.swift
//  kidGameSprite
//
//  Created by STEVE DURAN on 11/28/17.
//  Copyright © 2017 STEVE DURAN. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import CoreMotion

struct winningStruct{
    var number: Int
    init() {
        number = Int(arc4random_uniform(21) + 10)
    }
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //variables
    var skyScene:SKEmitterNode!
    var winningNumber = winningStruct()
    var tieFighter: SKSpriteNode!
    var shapeHolder:SKSpriteNode!
    var shapesArrayList = ["triangle,","circle","square","rectangle","hexagon","pentagon"]
    //variable for score
    var scoreLabel: SKLabelNode!
    var winningLabel: SKLabelNode!
    var starHit : Bool = false
    var score : Int = 0{
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    //this will make a timer so the shapes will appear every x seconds
    var shapeTimer: Timer!
    
    
    // create bitmask for torpedo and alien
    //deals with collision
    //intialize bitmask
    //categories
    let shapeCategory: UInt32 = 0x1 << 1 // this is a bite wise shfit less that is a unique identifer to detect collision
    let tieFighterCategory: UInt32 = 0x1 << 0
    let shipCategory: UInt32 = 0x1 << 0
    
    
    
    override func didMove(to view: SKView) {
        
        //gamescreen and label
        shapeGameImage()
  
        //timer for shapes
        //var Timer = NSTimer.scheduledTimerWithInterval(2, target: self, selector: Selector(addShapes()), userInfo: nil, repeats: true)
        
        self.shapeTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(addShapes), userInfo: nil,repeats: true)
        
        
    }
    
    func randWinningNumber()-> Int {
        let randomNumber = arc4random_uniform(21) + 10
        return Int(randomNumber)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func shapeGameImage() {
        
        skyScene = SKEmitterNode(fileNamed: "SkyScene")
        // skyScene.particlePositionRange = CGSize(x:3,y:3)
        skyScene.position = CGPoint(x: size.width-600,y:size.height)
        skyScene.advanceSimulationTime(12) // advances the sks file. We simulate it a couple seconds
        addChild(skyScene)
        
        skyScene.zPosition = -1 // the main background
        
        //score label
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x:250 ,y:self.frame.height - 110)
        scoreLabel.fontSize = 65
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontColor = SKColor.white
        addChild(scoreLabel)
        
        
        winningLabel = SKLabelNode(text: "Goal #: \(winningNumber.number)")
        winningLabel.position = CGPoint(x:950 ,y:self.frame.height - 110)
        winningLabel.fontSize = 65
        winningLabel.fontName = "Chalkduster"
        winningLabel.fontColor = SKColor.white
        addChild(winningLabel)
        
        //place ship
        tieFighter = SKSpriteNode(imageNamed: "tieFighter")
        tieFighter.name = "tieFighter"
        tieFighter.position = CGPoint(x: self.frame.size.width/2 ,y: 150)
     
        
        addChild(tieFighter)
        
       // self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
    }
    
    @objc func addShapes() {
        //all of our array have different position
        //shufles the array
        
        
        
        let randomNumber = arc4random_uniform(10) + 1
        if randomNumber == 9 || randomNumber == 10 {
            shapeHolder = SKSpriteNode(imageNamed: "star")
            
            //set userData
            shapeHolder.userData = ["ImageNamed": "star"]
        }else {
            shapesArrayList = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: shapesArrayList) as! [String]
            
        
            //there will always be a new shape at the beginning of the array, choose it
            shapeHolder = SKSpriteNode(imageNamed: shapesArrayList[0]) //
            
            //set userData
            shapeHolder.userData = ["ImageNamed": shapesArrayList[0]]
        }
        
    
        
        //dimesion of the iphone screen
        let shapePosition = GKRandomDistribution(lowestValue: Int(shapeHolder.frame.size.width),highestValue: Int(self.frame.size.width - shapeHolder.frame.size.width))
        
        //creates random position
        let position = CGFloat(shapePosition.nextInt()) // conversion from cgpoint to cgfloat
        
        //placing the sprite on the screen
        shapeHolder.position = CGPoint(x: position ,y: self.frame.size.height) // self -> equals height of the screen
        
        //deals with collision and th ephysic behind it
        //this will shape the body of the node by the dimension of the image
        shapeHolder.physicsBody = SKPhysicsBody(rectangleOf: shapeHolder.size)
        shapeHolder.physicsBody?.isDynamic = true
        
        //this will deal with collision
        shapeHolder.physicsBody?.categoryBitMask = shapeCategory
        shapeHolder.physicsBody?.contactTestBitMask = tieFighterCategory // there should be contact between shooting of the tie fighter and shape
        
        shapeHolder.physicsBody?.collisionBitMask = 0
        
        self.addChild(shapeHolder)
        
        //animate the object to come down
        let shapeMoving:TimeInterval = 10
        
        //holds the sk actions we will be doing
        var actionCounterArray = [SKAction]()
        
        actionCounterArray.append(SKAction.move(to:CGPoint( x: position,y:-shapeHolder.size.height), duration: shapeMoving))
        actionCounterArray.append(SKAction.removeFromParent())
        
        shapeHolder.run(SKAction.sequence(actionCounterArray))
        
        
    }
    
    //deals with ship moving
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            tieFighter.position.x = location.x
            tieFighter.position.y = location.y
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tieFighterBlast()
    }
    
    
    //blast function
    func tieFighterBlast() {
       self.run(SKAction.playSoundFileNamed("blastSound.mp3", waitForCompletion: false))
        
        let tieBlastNode = SKSpriteNode(imageNamed: "blast")
        tieBlastNode.position = tieFighter.position
        tieBlastNode.position.y += 5
        
        //collision detection
        tieBlastNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tieBlastNode.size.width,height : tieBlastNode.size.height))
        tieBlastNode.physicsBody?.isDynamic = true
        
        // torpedo collision informaiton
        tieBlastNode.physicsBody?.categoryBitMask = tieFighterCategory
        tieBlastNode.physicsBody?.contactTestBitMask = shapeCategory // there should be contact
        tieBlastNode.physicsBody?.collisionBitMask = 0
        tieBlastNode.physicsBody?.usesPreciseCollisionDetection = true //more precise collision detetion
        
        self.addChild(tieBlastNode)
        
        // moving the shot upward
        let blastAnimation: TimeInterval = 0.9
        
        //holds the sk actions we will be doing
        var actionCounterArray = [SKAction]()
        
        actionCounterArray.append(SKAction.move(to:CGPoint( x: tieFighter.position.x ,y:self.frame.size.height), duration: blastAnimation))
        actionCounterArray.append(SKAction.removeFromParent())
        
        tieBlastNode.run(SKAction.sequence(actionCounterArray))
    }
    
    
    
    // this will detects if there was collision
    func didBegin(_ contact: SKPhysicsContact) {
        var bodyOne: SKPhysicsBody
        var bodyTwo: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bodyOne  = contact.bodyA
            bodyTwo = contact.bodyB
        }else{
            bodyOne = contact.bodyB
            bodyTwo = contact.bodyA
        }
        
        
        //figures out which body is the tieBlast and which is the shape
        //compare bitwise . which one are identical
        
        if (bodyOne.categoryBitMask & tieFighterCategory) != 0 && (bodyTwo.categoryBitMask & shapeCategory) != 0 {
            //collision function
            tieFighterCollision(blastNode: bodyOne.node as! SKSpriteNode,shapeNode: bodyTwo.node as! SKSpriteNode)
        }/*else if (bodyOne.categoryBitMask & shipCategory) != 0 && (bodyTwo.categoryBitMask & shapeCategory) != 0 {
            //collision function
            exit(0)
        }*/
    }
    
    func loseGame() -> Bool {
        if (score < 0){
            return true
        }else if score > winningNumber.number{
            return true
        }else{
            return false
        }
    }
    
    func winGame() -> Bool {
        if(score == winningNumber.number){
            return true
        }else{
            return false
        }
    }
    
    func checkWinningScore(){
        if(loseGame()){
            print("Below Zero")
            if let view = self.view {
                
                if let endScene = SKScene(fileNamed: "EndGameScene") {
                    endScene.scaleMode = .aspectFill
                    
                    //present the screen
                    view.presentScene(endScene)
                }
                
                view.ignoresSiblingOrder = true
                view.showsFPS = false
                view.showsNodeCount = false
            }
            
        }
        else if(winGame()){
            //win the game
            print("Below Zero")
            if let view = self.view {
                
                if let endScene = SKScene(fileNamed: "WinningScene") {
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
    
    //after detecting collision, execute this
    func tieFighterCollision(blastNode: SKSpriteNode,shapeNode: SKSpriteNode){
        let blastVisual = SKEmitterNode(fileNamed: "Fireworks")!
        
        //set the blast at the position of shape node
        blastVisual.position = shapeNode.position
        
        //decides score
        if let imageName = shapeNode.userData?["ImageNamed"] as? String {
            if imageName == "square"{
                if starHit == true {
                    score -= 1
                    starHit = false
                    checkWinningScore()
                
                }else {
                    score += 1
                    checkWinningScore()
                    
                }
                
            }
            else if imageName == "circle"{
                if starHit == true {
                    score -= 2
                    starHit = false
                    checkWinningScore()
                }else {
                    score += 2
                    checkWinningScore()
                }
            }
            else if imageName == "triangle" {
                if starHit == true {
                    score -= 3
                    starHit = false
                    checkWinningScore()
                }else {score += 3
                    checkWinningScore()
                }
            }
            else if imageName == "rectangle" {
                if starHit == true {
                    score -= 4
                    starHit = false
                    checkWinningScore()
                }else {score += 4
                    checkWinningScore()
                }
            }
            else if imageName == "hexagon" {
                if starHit == true {
                    score -= 5
                    starHit = false
                    checkWinningScore()
                }else {score += 5
                    checkWinningScore()
                }
            }
            else if imageName == "pentagon" {
                if starHit == true {
                    score -= 6
                    starHit = false
                    checkWinningScore()
                }else {score += 6
                    checkWinningScore()
                }
            }
            else if imageName == "star" {
                starHit = true
            }
            else {
                print("Nothing")
            }
        }
        
        self.addChild(blastVisual)
        self.run(SKAction.playSoundFileNamed("blowingUp.mp3", waitForCompletion: false))
        
        blastNode.removeFromParent()
        shapeNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 1)){
            blastVisual.removeFromParent()
        }
        
    }
    
    
}


/*
 if(endGame()){
 print("Below Zero")
 let transition = SKTransition.flipVertical(withDuration: 1.5)
 let gameScene =  EndGameScene(size:CGSize(width: self.frame.size.width, height: self.frame.size.height))
 self.view?.presentScene(gameScene, transition: transition)
 }
 */

