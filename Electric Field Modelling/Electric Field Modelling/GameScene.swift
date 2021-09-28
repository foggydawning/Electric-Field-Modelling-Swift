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
    var u: InteractionField! = InteractionField()
    let charges: [CGPoint] = [
        CGPoint(x: 200, y: 200),
        CGPoint(x: 200, y: -200)
    ]
    
    
    func setCharges(charges: [CGPoint]){
        for charge in charges{
            let node = SKShapeNode(circleOfRadius: 10)
            node.position = charge
            node.fillColor = UIColor.blue
            self.addChild(node)
        }
    }
    
    
    func setMainCharge(mainChargeCoordinates: CGPoint){
        firstCharge = SKShapeNode(circleOfRadius: 20)
        firstCharge.position = mainChargeCoordinates
        firstCharge.fillColor = UIColor.blue
    }

    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        
        setMainCharge(mainChargeCoordinates: CGPoint(x: 0, y: 0))
        u.setPoints(pointsCoordinates: charges +
            [CGPoint(x: firstCharge.position.x , y: firstCharge.position.y)]
        )
        
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
        setCharges(charges: charges)
        self.addChild(firstCharge)
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: self)
                
                self.removeAllChildren()
    
                firstCharge.position.x = touchLocation.x
                firstCharge.position.y = touchLocation.y
            
                var res: [[CGPoint]] = []
            
                u.resetPoints(pointsCoordinates: charges +
                    [CGPoint(x: firstCharge.position.x , y: firstCharge.position.y)]
                )
            
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
                setCharges(charges: charges)
                self.addChild(firstCharge)
        }
    }
}
