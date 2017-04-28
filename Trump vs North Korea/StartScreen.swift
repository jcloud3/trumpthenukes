//
//  StartScreen.swift
//  Trump vs North Korea
//
//  Created by mtech on 4/24/17.
//  Copyright © 2017 Cloudy. All rights reserved.
//

import Foundation
import SpriteKit

class StartScreen: SKScene{
    var selectedNode = SKSpriteNode()
    let label = SKLabelNode(fontNamed: "Optima-Bold")
    let prefs = UserDefaults.standard
    let title = SKLabelNode(fontNamed: "Optima-Bold")
    let button = SKSpriteNode(imageNamed: "Start")

    override init(size: CGSize){
        let highScore = String(prefs.integer(forKey: "highScore"))
        super.init(size: size)
        backgroundColor = SKColor.black
        label.name = "label"
        label.text = "HIGH SCORE: \(highScore)"
        label.fontSize = 22
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        title.text = "Trump the Nukes!"
        title.fontSize = 40
        title.fontColor = SKColor.red
        title.position = CGPoint(x: size.width/2, y: size.height*0.8)
        addChild(title)
        
        button.position = CGPoint(x: size.width/2, y: size.height*0.2)
        button.name = "start"
        button.setScale(2)
        
        button.zPosition = 10
        addChild(button)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
        
        
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
        let loc = touch.location(in: self)
        let node : SKNode = atPoint(loc)
            print("\(String(describing: node.name))")
        if node.name == "start"{
            run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run(){
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: self.size, scoreNum: 0, levelNum: 1, healthNum: 5)
                self.view?.presentScene(scene, transition:reveal)}]))
        }
        }
        
    }
    
            
}
            
            

            
            
            
            
            
            


