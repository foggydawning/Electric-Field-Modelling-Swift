//
//  GameScene.swift
//  Electric Field Modelling
//
//  Created by Илья Чуб on 27.09.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var firstCharge: SKShapeNode!
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        firstCharge = SKShapeNode(circleOfRadius: 20)
        firstCharge.position = CGPoint(x: 0, y: -300)
        firstCharge.fillColor = UIColor.blue
        self.addChild(firstCharge)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
