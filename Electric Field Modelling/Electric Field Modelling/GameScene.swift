//
//  GameScene.swift
//  Electric Field Modelling
//
//  Created by Илья Чуб on 27.09.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var equipotentialMode: Bool = false
    
    let screenWidth: Double = UIScreen.main.bounds.width*0.7
    let screenHeight: Double = UIScreen.main.bounds.height*0.8
    
    /// coofficient to translate cm to points
    var sizeCoefficient: Double {screenWidth/28}
    
    /// charges in batteries
    var charges: [Point] {createCharges()}
    
    /// ring as physical object
    var ring: Ring!
    /// ring as node
    var ringNode: SKShapeNode! = SKShapeNode()
    
    /// electric field
    var field: InteractionField! = InteractionField()
    
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
            
            let node: SKSpriteNode!
            if charge.q < 0{
                node = SKSpriteNode(imageNamed: "electric ball blue")
            } else {
                node = SKSpriteNode(imageNamed: "electric ball red")
            }
            node.size = CGSize(width: 60, height: 60)
            node.position = charge.CGPCoord()
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
        ringNode.name = "ring"
        if equipotentialMode{
            ringNode.glowWidth = 5
        }
    }
    
    
    /// get a set of coordinates for drawing field strength lines
    func getInten() -> [[CGPoint]] {
        var res: [[CGPoint]] = []
        for x in stride(from: -screenWidth/2, to: screenWidth/2, by: 17){
            for y in stride(from: -screenHeight/2, to: screenHeight/2, by: 15){
                if pow(ringNode.position.x - x, 2)
                    + pow(ringNode.position.y - y, 2)
                    <= pow(ring.outerRadius-7,2){
                    continue
                }
                let point: Point = Point(x: x, y: y)
                var inten = field.intensity(coord: point.vectorCoord())
                
                inten = inten
                    .div( inten.mod( Vector(x: 0, y: 0)) * 0.03)
                    .div(2)
                
                res.append(
                    [CGPoint(x: x - inten.x, y: y - inten.y),
                    CGPoint(x: x + inten.x, y: y + inten.y)
                    ])
                }
            }
        return res
    }
    
    func getEquipotential(){
        for y in stride(from: -screenHeight/2, to: screenHeight/2+10, by: 2){
            for x in stride(from: -screenWidth/2, to: screenHeight/2+10, by: 2){
                if pow(ringNode.position.x - x, 2)
                    + pow(ringNode.position.y - y, 2)
                    <= pow(ring.outerRadius-7,2){
                    continue
                }
                let point: Point = Point(x: x, y: y)
                let potential = abs(field.equipotential(coord: point.vectorCoord()))
                
                if  -0.01 < potential && potential < 0.01 ||
                    0.98 < potential && potential < 1.02 ||
                    9.98 < potential && potential < 10.02 ||
                    19.97 < potential && potential < 20.03 ||
                    29.9 < potential && potential < 30.1 ||
                    39.80 < potential && potential < 40.20 ||
                    44.80 <= potential && potential <= 45.20 ||
                    49.80 <= potential && potential <= 50.20 ||
                    54.80 <= potential && potential <= 55.20 ||
                    59.92 <= potential && potential <= 60.08 ||
                    69.8 <= potential && potential <= 70.2 ||
                    79.78 <= potential && potential <= 80.22 ||
                    89.56 <= potential && potential <= 90.42 ||
                        99 <= potential && potential <= 101
                {
                    let node = SKShapeNode(circleOfRadius: 3)
                    node.position = CGPoint(x: x, y: y)
                    node.fillColor = .purple
                    node.glowWidth = 1
                    self.addChild(node)
                }
            }
        }
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
    
    func setButton(){
        let node = SKShapeNode(rect: CGRect(origin: CGPoint(x: 428, y: 268), size: CGSize(width: 50, height: 50)), cornerRadius: 5)
        
        node.fillColor = .purple
        node.strokeColor = .purple
        node.glowWidth = 3
        node.lineWidth = 4
        node.name = "mybutton"
        if equipotentialMode{
            node.glowWidth = 4
            node.strokeColor = .white
        }
        self.addChild(node)
    }
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.isDynamic = false

        setButton()
        setRing()
        createRingNode(ring)
        
        field.setPoints(points: charges)
        let res: [[CGPoint]] = getInten()
        drawLines(res: res)
        setCharges(charges: charges)
        self.addChild(ringNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            let someNode = self.atPoint(touchLocation)
            if someNode.name == "mybutton"{
                equipotentialMode.toggle()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if equipotentialMode == false{
            for touch in touches {
                let touchLocation = touch.location(in: self)
                let someNode: some SKNode = self.atPoint(touchLocation)
                if someNode.name == "ring"{
                    ringNode.position.x = touchLocation.x
                    ringNode.position.y = touchLocation.y
                }
            }
        }
    }

    
    
    override func update(_ currentTime: TimeInterval) {
    
        self.removeAllChildren()
        field.resetPoints(points: charges)
        let res: [[CGPoint]] = getInten()
        drawLines(res: res)
        setButton()
        setCharges(charges: charges)
        self.addChild(ringNode)
        if equipotentialMode{
            getEquipotential()
        }
        
    }
}
