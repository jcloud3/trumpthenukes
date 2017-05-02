//
//  LevelChange.swift
//  Trump the Nukes
//
//  Created by jcloud on 4/21/17.
//  Copyright © 2017 Cloudy. All rights reserved.
//

import Foundation
import SpriteKit

class LevelChange: SKScene{
    let prefs = UserDefaults.standard
    
    var scores = 0
    var levels = 0
    var healths = 0
    init(size: CGSize, score: Int, level: Int, health: Int){
        super.init(size: size)
        let highScore = String(prefs.integer(forKey: "highScore"))
        scores = score
        levels = level
        healths = health
        backgroundColor = SKColor.black
        let high = SKLabelNode(fontNamed: "Optima-Bold")
        high.text = "High Score: \(highScore)"
        high.fontSize = 30
        high.fontColor = SKColor.red
        high.position = CGPoint(x: size.width*0.5, y: size.height*0.45)
        addChild(high)
        
        let message = "You passed level \(level)!"
        let label = SKLabelNode(fontNamed: "Optima-Bold")
        label.text = message
        label.fontSize = 30
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height*0.8)
        
        addChild(label)
        let message2 = "Current Score: \(score)"
        let label2 = SKLabelNode(fontNamed: "Optima-Bold")
        label2.text = message2
        label2.fontSize = 30
        label2.fontColor = SKColor.red
        label2.position = CGPoint(x: size.width/2, y: size.height*0.6)
        
        addChild(label2)
        let button = SKSpriteNode(imageNamed: "Cont")
        button.position = CGPoint(x: size.width/2, y: size.height*0.2)
        button.name = "continue"
        button.setScale(2)
        
        button.zPosition = 10
        addChild(button)
        
        
        
        
    }
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let loc = touch.location(in: self)
            let node : SKNode = atPoint(loc)
            print("\(String(describing: node.name))")
            if node.name == "continue"{
                run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run(){
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let scene = GameScene(size: self.size, scoreNum: self.scores, levelNum: self.levels+1, healthNum: self.healths)
                    self.view?.presentScene(scene, transition:reveal)}]))
            }
        }
        
        
        
    }

}
