//
//  GameOverScene.swift
//  Trump the Nukes
//
//  Created by jcloud on 4/19/17.
//  Copyright © 2017 Cloudy. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    let prefs = UserDefaults.standard
    
    init(size: CGSize, score: Int){
        
        super.init(size: size)
        backgroundColor = SKColor.black
        let highScore = String(prefs.integer(forKey: "highScore"))
        if (score>Int(highScore)!){
            prefs.setValue(score, forKey: "highScore")
        }
        let back = SKSpriteNode(imageNamed: "Kim")
        back.zPosition = -1
        back.setScale(2)
        back.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        addChild(back)
        backgroundColor = SKColor.white
        let high = SKLabelNode(fontNamed: "Optima-Bold")
        high.text = "High Score: \(highScore)"
        high.fontColor = SKColor.black
        high.position = CGPoint(x: size.width*0.5, y: size.height*0.88)
        let message = "You Lose. Your Score: \(score)"
        let label = SKLabelNode(fontNamed: "Optima-Bold")
        label.text = message
        label.fontSize = 30
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width*0.5, y: size.height*0.93)
        addChild(label)
        addChild(high)
        let button = SKSpriteNode(imageNamed: "Cont")
        button.position = CGPoint(x: size.width/2, y: size.height*0.1)
        button.name = "continue"
        button.setScale(2)
        
        button.zPosition = 10
        addChild(button)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let loc = touch.location(in: self)
            let node : SKNode = atPoint(loc)
            print("\(String(describing: node.name))")
            if node.name == "continue"{
                run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run(){
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let scene = StartScreen(size: self.size)
                    self.view?.presentScene(scene, transition:reveal)}]))
            }
        }
        
        
        
    }
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}
