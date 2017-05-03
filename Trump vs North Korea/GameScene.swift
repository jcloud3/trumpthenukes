//
//  GameScene.swift
//  Trump vs North Korea
//
//  Created by mtech on 4/18/17.
//  Copyright © 2017 Cloudy. All rights reserved.
//

import SpriteKit
import GameplayKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func / (left: CGPoint, right: CGPoint) -> CGFloat {
    return CGFloat((left.y - right.y)/(left.x - right.x))
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let missile : UInt32 = 0b1
    static let laser : UInt32 = 0b10
    static let bottom : UInt32 = 0b11
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var spreadCount = 0
    var maxShots = 4
    var highScore = UserDefaults().integer(forKey: "HIGHSCORE")
    var level = 1
    var stop = SKAction.run(){}
    var shotCount = 0
    let player = SKSpriteNode(imageNamed: "player")
    let background = SKSpriteNode(imageNamed: "Map")
    var health = 5
    var score = 0
    var scoreLabel = SKLabelNode()
    let scoreLabelName = "scoreLabel"
    var levelLabel = SKLabelNode()
    let levelLabelName = "levelLabel"
    var healthLabel = SKLabelNode()
    let healthLabelName = "healthLabel"
    var changeLabel = SKLabelNode()
    let changeLabelName = "changeLabel"
    var modifier = 0.0
    init(size: CGSize, scoreNum: Int, levelNum: Int, healthNum: Int) {
        super.init(size: size)
        level = levelNum
        score = scoreNum
        health = healthNum
        modifier = Double(level)
        if level%5==0{
            maxShots += 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func didMove(to view: SKView) {
        background.setScale(3)
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.zPosition = -1
      
        scoreLabel = SKLabelNode(fontNamed: "Optima-Bold")
        scoreLabel.name = scoreLabelName
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.white
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: frame.size.width*0.8, y: frame.size.height * 0.97)
        
        levelLabel = SKLabelNode(fontNamed: "Optima-Bold")
        levelLabel.name = levelLabelName
        levelLabel.fontSize = 20
        levelLabel.fontColor = SKColor.white
        levelLabel.text = "Level: \(level)"
        levelLabel.position = CGPoint(x: frame.size.width*0.2, y: frame.size.height * 0.97)
        
        healthLabel = SKLabelNode(fontNamed: "Optima-Bold")
        healthLabel.name = healthLabelName
        healthLabel.fontSize = 20
        healthLabel.fontColor = SKColor.red
        healthLabel.text = "Health: \(health)"
        healthLabel.position = CGPoint(x: frame.size.width*0.5 , y: frame.size.height * 0.97)
        
        
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        self.addChild(background)
        self.addChild(scoreLabel)
        self.addChild(healthLabel)
        self.addChild(levelLabel)
        addChild(player)
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        if (level>7){
            modifier = 7.0
        }
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run(addMissile), SKAction.wait(forDuration: Double(random(min: CGFloat(1.6-modifier*0.2), max: CGFloat(2.6-modifier*0.2))))])))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMissile() {
        if (score>=level*level){
            self.removeAllChildren()
            
            levelMove()
        }
        let bonus = (random(min: 0.0, max: 100.0))
        let missile: SKSpriteNode
        if bonus < 2{
            missile = SKSpriteNode(imageNamed: "Rapid Fire")
            missile.name = "RF"
        }
        else if bonus < 4{
            missile = SKSpriteNode(imageNamed: "Spread")
            missile.name = "S"
        }
        else if bonus < 6{
            missile = SKSpriteNode(imageNamed: "Health")
            missile.name = "H"
        }
        else{
            missile = SKSpriteNode(imageNamed: "NK")
            missile.name = "NK"
        }
        
        let actualx = random(min: missile.size.width/2, max: size.width - missile.size.width/2)
        
        
        missile.position = CGPoint(x: actualx, y:size.height + missile.size.height/2)
        
        addChild(missile)
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
        missile.physicsBody?.isDynamic = true
        missile.physicsBody?.categoryBitMask = PhysicsCategory.missile
        missile.physicsBody?.contactTestBitMask = PhysicsCategory.laser
        missile.physicsBody?.collisionBitMask = PhysicsCategory.None
        var actualDuration = CGFloat(0.0)
        if (level<9){
        actualDuration = random(min: CGFloat(5.0-(CGFloat(level) * 0.3)), max: CGFloat(5.0))
        }
        else{
        actualDuration = random(min: CGFloat(1.5), max: CGFloat(5.0))
        }
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualx, y: size.height * 0), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.run(){
            missile.removeFromParent()
            self.health-=1
            self.healthLabel.text = "Health: \(self.health)"
            }
        let loseAction = SKAction.run(){
            if (self.health == 1){
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, score: self.score)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
        }
        

        
        missile.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
        
    }
    func levelMove(){
        self.removeAllChildren()
        self.addChild(background)
        self.addChild(scoreLabel)
        self.addChild(healthLabel)
        self.addChild(levelLabel)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let levelChangeAction = LevelChange(size: self.size, score: self.score, level: self.level, health: self.health)
        self.view?.presentScene(levelChangeAction, transition: reveal)
        addChild(player)
    
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        
        let laser = SKSpriteNode(imageNamed: "Laser")
        laser.position = player.position
        
        
        
        
        let offset = touchLocation - laser.position
        
        
        if (shotCount<maxShots){
            addChild(laser)
            shotCount=shotCount+1
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.laser
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.missile
        laser.physicsBody?.collisionBitMask = PhysicsCategory.None
        laser.physicsBody?.usesPreciseCollisionDetection = true
        
        
        let direction = offset.normalized()
        
        
        let shootAmount = direction * 1000
        
        var realDest = shootAmount + laser.position
        
            if realDest.x != laser.position.x{
                let slope = realDest/laser.position
            
        
        let b = -(realDest.x*slope-realDest.y)
            if slope==0 && realDest.x<0{
                realDest = CGPoint(x: 0, y: realDest.y)
            }
            else if slope==0 && realDest.x>self.size.width{
                realDest = CGPoint(x: self.size.width, y: realDest.y)
            }
            else if slope>0 && realDest.x>laser.position.x{
                if slope>CGPoint(x: self.size.width, y: self.size.height)/laser.position{
                    realDest = CGPoint(x: (self.size.height-b)/slope, y: self.size.height)
                }
                else if slope<CGPoint(x: self.size.width, y: self.size.height)/laser.position{
                    realDest = CGPoint(x: self.size.width, y: slope*self.size.width + b)
                }
                else{
                    realDest = CGPoint(x: self.size.width, y: self.size.height)
                }
            }
            else if slope>0 && realDest.x<laser.position.x{
                if slope>CGPoint(x: 0, y: 0)/laser.position{
                    realDest = CGPoint(x: -b/slope, y: 0)
                }
                else if slope<CGPoint(x: 0, y: 0)/laser.position{
                    realDest = CGPoint(x: 0, y: b)
                }
                else{
                    realDest = CGPoint(x: 0, y: 0)
                }
            }

            else if slope<0 && realDest.x<laser.position.x{
                
                if abs(slope)>abs(CGPoint(x: 0, y: self.size.height)/laser.position){
                    realDest = CGPoint(x: (self.size.height-b)/slope, y: self.size.height)
                }
                else if abs(slope)<abs(CGPoint(x: 0, y: self.size.height)/laser.position){
                    realDest = CGPoint(x: 0, y: b)
                }
                else{
                    realDest = CGPoint(x: 0, y: self.size.height)
                }
                }
            else if slope<0 && realDest.x>laser.position.x{
                if abs(slope)>abs(CGPoint(x: self.size.width, y: 0)/laser.position){
                    realDest = CGPoint(x: (0-b)/slope, y: 0)
                }
                else if abs(slope)<abs(CGPoint(x: self.size.width, y: 0)/laser.position){
                    realDest = CGPoint(x: self.size.width, y: slope*self.size.width + b)
                }
                else{
                    realDest = CGPoint(x: self.size.width, y: 0)
                }
                }
            }
            else {
                realDest = CGPoint(x: laser.position.x, y: self.size.height)
            }
            
            let actionMove = SKAction.move(to: realDest, duration: Double(distance(xpoint: player.position, ypoint: realDest)/CGFloat(115.0)))
            let actionMoveDone = SKAction.run(){
                SKAction.removeFromParent()
                self.shotCount=self.shotCount-1
            }
        laser.run(SKAction.sequence([actionMove, actionMoveDone]))
            
        }
        
    }
    
    func laserDidCollideWithMissile(laser: SKSpriteNode, missile: SKSpriteNode) {
        if missile.name == "H"{
            health += 1
            healthLabel.removeFromParent()
            addChild(healthLabel)
        }
        else if missile.name == "RF"{
            
        }
        else if missile.name == "S"{
            
        }
        score += 1
        //if score>
        scoreLabel.text = "Score: \(score)"
        laser.removeFromParent()
        shotCount=shotCount-1
        missile.removeFromParent()
    }
    func distance (xpoint: CGPoint, ypoint: CGPoint) -> CGFloat{
        return sqrt(pow((xpoint.x-ypoint.x),2)+pow((xpoint.y-ypoint.y),2))
    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.missile != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.laser != 0)) {
            if let missile = firstBody.node as? SKSpriteNode, let
                laser = secondBody.node as? SKSpriteNode {
                laserDidCollideWithMissile(laser: laser, missile: missile)
            }
        }
        
    }
    
    }
