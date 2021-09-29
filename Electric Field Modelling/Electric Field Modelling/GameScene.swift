//
//  GameScene.swift
//  Electric Field Modelling
//
//  Created by Илья Чуб on 27.09.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    let screenWidth: Double = UIScreen.main.bounds.width
    let screenHeight: Double = UIScreen.main.bounds.height
    
    /// coofficient to translate cm to points
    var sizeCoefficient: Double {screenWidth/28}
    
    /// charges in batteries
    var charges: [Point] {createCharges()}
    
    /// ring as physical object
    var ring: Ring!
    /// ring as node
    var ringNode: SKShapeNode! = SKShapeNode()
    
    /// electric field
    var field: InteractionField! = InteractionField() // field
    
    func createCharges() -> [Point]{
        var charges: [Point] = []
        for y in stride(from: -18*sizeCoefficient/2, to: 18*sizeCoefficient/2, by: 60){
            charges.append(Point(x: -screenWidth/2 + 50, y: y + 10))
        }
        for y in stride(from: -18*sizeCoefficient/2, to: 18*sizeCoefficient/2, by: 60){
            charges.append(Point(x: screenWidth/2 - 50, y: y + 10, q: -1))
        }
        return charges
    }
    
    func setCharges(charges: [Point]){
        for charge in charges{
            let node = SKShapeNode(circleOfRadius: 10)
            node.position = charge.CGPCoord()
            node.glowWidth = 5.0
            if charge.q < 0{
                node.fillColor = UIColor.red
            } else {
                node.fillColor = UIColor.blue
            }
            self.addChild(node)
        }
    }
    
    func setRing(){
        ring = Ring(center: CGPoint(x: 0, y: 0),
                             outerRadius: 7*sizeCoefficient,
                             width: 1*sizeCoefficient)
    }
    
    func createRingNode(_ ring: Ring){
        ringNode = SKShapeNode(circleOfRadius: ring.innerRadius)
        ringNode.lineWidth = ring.width
        ringNode.strokeTexture =  SKTexture(imageNamed: "metal")
    }
    
    
    /// get a set of coordinates for drawing field strength lines
    func getInten() -> [[CGPoint]] {
        var res: [[CGPoint]] = []
        for x in stride(from: -screenWidth/2, to: screenWidth/2, by: 21){
            for y in stride(from: -screenHeight/2, to: screenHeight/2, by: 21){
                if pow(ringNode.position.x - x, 2) + pow(ringNode.position.y - y, 2) <= pow(ring.outerRadius-7,2){
                    continue
                }
                let point: Point = Point(x: x, y: y)
                var inten = field.intensity(coord: point.vectorCoord())
                
                inten = inten
                    .div( inten.mod( Vector(x: 0, y: 0)) * 0.01)
                    .div(2)
                
                res.append(
                    [CGPoint(x: x - inten.x, y: y - inten.y),
                    CGPoint(x: x + inten.x, y: y + inten.y)
                    ])
                }
            }
        return res
    }
    
    
    /// drawing field strength lines
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

        setRing()
        createRingNode(ring)
        
        field.setPoints(points: charges)
        let res: [[CGPoint]] = getInten()
        drawLines(res: res)
        setCharges(charges: charges)
        self.addChild(ringNode)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            ringNode.position.x = touchLocation.x
            ringNode.position.y = touchLocation.y
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        self.removeAllChildren()
        field.resetPoints(points: charges)
        let res: [[CGPoint]] = getInten()
        drawLines(res: res)
        setCharges(charges: charges)
        self.addChild(ringNode)
    }
}
