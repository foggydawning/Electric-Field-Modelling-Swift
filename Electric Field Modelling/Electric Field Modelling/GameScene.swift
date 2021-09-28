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
    var secondCharge: SKShapeNode!
    var thirdCharge: SKShapeNode!
    var u: InteractionField!
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        firstCharge = SKShapeNode(circleOfRadius: 20)
        firstCharge.position = CGPoint(x: -200, y: -200)
        firstCharge.fillColor = UIColor.blue
        
        secondCharge = SKShapeNode(circleOfRadius: 10)
        secondCharge.position = CGPoint(x: 200, y: 200)
        secondCharge.fillColor = UIColor.blue
        
        thirdCharge = SKShapeNode(circleOfRadius: 10)
        thirdCharge.position = CGPoint(x: 200, y: -200)
        thirdCharge.fillColor = UIColor.blue
        
        u = InteractionField(points: [
            Point(x: firstCharge.position.x, y: firstCharge.position.y, q: 2.0),
            Point(x: secondCharge.position.x, y: secondCharge.position.y),
            Point(x: thirdCharge.position.x, y: thirdCharge.position.y)
        ])
        
        var res: [[CGPoint]] = []
        
        for x in stride(from: -500.0, to: 520, by: 15){
            for y in stride(from: -400.0, to: 400.0, by: 15){
                var inten = u.intensity(coord: Vector(x: Double(x), y: Double(y)))
                inten = inten.div( inten.mod( Vector(x: 0, y: 0)) ).mult(30)
                inten = inten.div(2)
                res.append(
                    [
                        CGPoint(x: Double(x) - inten.x, y: Double(y) - inten.y),
                        CGPoint(x: Double(x) + inten.x, y: Double(y) + inten.y)
                    ]
                )
            }
        }
        
        for _points in res{
            var points = _points
            self.addChild(SKShapeNode(points: &points, count: points.count))
        }

        
        self.addChild(firstCharge)
        self.addChild(secondCharge)
        self.addChild(thirdCharge)
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: self)
                
                self.removeAllChildren()
                self.addChild(firstCharge)
                self.addChild(secondCharge)
                self.addChild(thirdCharge)
                firstCharge.position.x = touchLocation.x
                firstCharge.position.y = touchLocation.y
                var res: [[CGPoint]] = []
                u = InteractionField(points: [
                    Point(x: firstCharge.position.x, y: firstCharge.position.y, q: 2.0),
                    Point(x: secondCharge.position.x, y: secondCharge.position.y),
                    Point(x: thirdCharge.position.x, y: thirdCharge.position.y)
                ])
                for x in stride(from: -500.0, to: 520, by: 15){
                    for y in stride(from: -400.0, to: 400.0, by: 15){
                        var inten = u.intensity(coord: Vector(x: Double(x), y: Double(y)))
                        inten = inten.div( inten.mod( Vector(x: 0, y: 0)) ).mult(30)
                        inten = inten.div(2)
                        res.append(
                            [
                                CGPoint(x: Double(x) - inten.x, y: Double(y) - inten.y),
                                CGPoint(x: Double(x) + inten.x, y: Double(y) + inten.y)
                            ]
                        )
                    }
                }
                
                for _points in res{
                    var points = _points
                    self.addChild(SKShapeNode(points: &points, count: points.count))
                }
                
                
                
            
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
    
 
}
