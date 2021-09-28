//
//  GameScene.swift
//  Electric Field Modelling
//
//  Created by Илья Чуб on 27.09.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var mainCharge: SKShapeNode!
    var u: InteractionField! = InteractionField()
    let charges: [Point] = [
//        Point(x: 400, y: 250),
//        Point(x: 400, y: 200),
//        Point(x: 400, y: 150),
//        Point(x: 400, y: 100),
//        Point(x: 400, y: 50),
//        Point(x: 400, y: 0),
//        Point(x: 400, y: -50),
//        Point(x: 400, y: -100),
//        Point(x: 400, y: -150),
//        Point(x: 400, y: -200),
//        Point(x: 400, y: -250)
        
        Point(x: -300, y: -300),
        Point(x: 300, y: 300)
//        Point(x: -200, y: 200, q: 10.0)
    ]
    
    
    func setCharges(charges: [Point]){
        for charge in charges{
            let node = SKShapeNode(circleOfRadius: 10)
            node.position = charge.CGPCoord()
            node.fillColor = UIColor.blue
            self.addChild(node)
        }
    }
    
    
    func setMainCharge(mainChargeCoordinates: CGPoint){
        mainCharge = SKShapeNode(circleOfRadius: 20)
        mainCharge.position = mainChargeCoordinates
        mainCharge.fillColor = UIColor.blue
    }
    
    
    func getInten() -> [[CGPoint]] {
        var res: [[CGPoint]] = []
        for x in stride(from: -500.0, to: 520.0, by: 20){
            for y in stride(from: -400.0, to: 400.0, by: 20){
                let point: Point = Point(x: x, y: y)
                var inten = u.intensity(coord: point.vectorCoord())
                
                inten = inten
                    .div( inten.mod( Vector(x: 0, y: 0)) )
                    .mult(32)
                    .div(2)
                
                res.append(
                    [CGPoint(x: x - inten.x, y: y - inten.y),
                    CGPoint(x: x + inten.x, y: y + inten.y)
                    ])
                }
            }
        return res
    }
    
    
    func drawLines(res: [[CGPoint]]){
        for _points in res{
            var points = _points
            if points[0].x.isNaN {
                continue
            }
            let node = SKShapeNode(points: &points, count: points.count)
            self.addChild(node)
        }
    }

    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.isDynamic = false
        
        setMainCharge(mainChargeCoordinates: CGPoint(x: 0, y: 0))
        u.setPoints(points: charges +
                    [Point(x: mainCharge.position.x , y: mainCharge.position.y)]
        )
        let res: [[CGPoint]] = getInten()
        drawLines(res: res)
        setCharges(charges: charges)
        self.addChild(mainCharge)
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            mainCharge.position.x = touchLocation.x
            mainCharge.position.y = touchLocation.y
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        self.removeAllChildren()
        u.resetPoints(points: charges +
                      [Point(x: mainCharge.position.x , y: mainCharge.position.y)]
        )
        let res: [[CGPoint]] = getInten()
        drawLines(res: res)
        setCharges(charges: charges)
        self.addChild(mainCharge)
    }
}
