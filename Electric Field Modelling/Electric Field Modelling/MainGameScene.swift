//
//  MainGameScene.swift
//  Electric Field Modelling
//
//  Created by Илья Чуб on 18.11.2021.
//

import SwiftUI
import SpriteKit
import Foundation

protocol ElFieldModelMainScene{
    var charges: [Charge] {get}
}

class MainGameScene: SKScene, ElFieldModelMainScene, ObservableObject {
    
    
    var charges: [Charge] = []
    
    var field = InteractionField()
    var chargeRadius: CGFloat = 20
    var lastModule: Int = 0
    var ringCenter: CGPoint = .zero
    var ringRadius: CGFloat = 150
    var ringNode: SKShapeNode = SKShapeNode.init(circleOfRadius: 150)
    var countOfRingCharges: Int = 0
    var eqMode: Bool = false
    
    
    func toggleEqMode(){
        eqMode.toggle()
    }
    func setCharges(){
        for y in stride(from: size.height*0.2, to: size.height*0.8, by: size.height/12){
            self.charges.append(Charge(x: size.width*0.05, y: Double(y), q: 10))
            self.charges.append(Charge(x: size.width*0.95, y: Double(y), q: -10))
        }
    }
    
    func setRing(){
        ringNode.strokeColor = .gray
        ringNode.lineWidth = 30
        ringNode.name = "Ring"
        ringCenter = ringNode.position
        
        
        self.addChild(ringNode)
        for x in stride(from: 0, to: ringRadius+1, by: 10){
            let y: CGFloat = pow(pow(ringRadius, 2)-pow(x, 2), 0.5)
            self.charges.append(Charge(x: ringCenter.x-x, y: ringCenter.y + y, q: -0.5))
            self.charges.append(Charge(x: ringCenter.x-x, y: ringCenter.y - y, q: -0.5))
            self.charges.append(Charge(x: ringCenter.x+x, y: ringCenter.y + y, q: +0.5))
            self.charges.append(Charge(x: ringCenter.x+x, y: ringCenter.y - y, q: +0.5))
            countOfRingCharges += 4
        }
    }
    
    func removeRingCharges(){
        for _ in 1...countOfRingCharges{
            charges.remove(at: charges.endIndex-1)
        }
    }
    
    func updateRingCharges(){
        ringCenter = ringNode.position
        for x in stride(from: 0, to: ringRadius+1, by: 10){
            let y: CGFloat = pow(pow(ringRadius, 2)-pow(x, 2), 0.5)
            self.charges.append(Charge(x: ringCenter.x-x, y: ringCenter.y + y, q: -0.5))
            self.charges.append(Charge(x: ringCenter.x-x, y: ringCenter.y - y, q: -0.5))
            self.charges.append(Charge(x: ringCenter.x+x, y: ringCenter.y + y, q: +0.5))
            self.charges.append(Charge(x: ringCenter.x+x, y: ringCenter.y - y, q: +0.5))
        }
    }
    
    func setChargesNodes(){
        var number: Int = 0
        for charge in charges {
            if abs(charge.q) == 0.5{
                continue
            }
            let node = SKShapeNode(circleOfRadius: chargeRadius)
            node.position = charge.CGPCoord()
            if charge.q < 0{
                node.fillColor = .blue
            } else{
                node.fillColor = .red
            }
            node.name = "charge \(number)"
            self.addChild(node)
            number += 1
        }
    }
    
    func drawLine(x: Double, y: Double){
        var x = x
        var y = y
        var lastPoint = CGPoint(x: x, y: y)
        var lastLine: [CGPoint] = [.zero, .zero]
        
        while
            10 <= x &&
            x < size.width - 10 &&
            y >= 10 &&
            y < size.height - 10 &&
            pow(x-ringCenter.x, 2) + pow(y-ringCenter.y, 2) > pow(Double(ringRadius+18), 2)
        {
            var inten = field.intensity(coord: Vector(x: x, y: y))
            inten = inten
                .div( inten.mod( Vector(x: 0, y: 0)) * 0.08)
            
            let startPoint = CGPoint(x: Double(round(x) ), y: Double(round(y)))
            let endPoint = CGPoint(x: Double(round(x+inten.x) ), y: Double(round(y + inten.y)))
            
            if endPoint == lastPoint ||
                abs(endPoint.x-lastLine[0].x) < 10 {
                break
            }
            var points: [CGPoint] = [startPoint, endPoint]
            
            let line = SKShapeNode(points: &points, count: 2)
            self.addChild(line)
            
            lastPoint = CGPoint(x: x, y: y)
            lastLine = points
            x = endPoint.x
            y = endPoint.y
        }
    }

    func drawLines(){
        let step: CGFloat = 30
        for x in stride(from: 10.0, to: size.width-10, by: step){
            for y in stride(from: 10.0, to: size.height-10, by: step){
                if x == 0 || y == 0 || pow(x-ringCenter.x, 2) + pow(y-ringCenter.y, 2) <= pow(Double(ringRadius), 2){
                    continue
                }
                drawLine(x: Double(x), y: Double(y))
            }
        }
        
    }
    
//    func changeChargesCoordinate(numberOfCharge: Int, coord: CGPoint){
//        charges[numberOfCharge].x = coord.x
//        charges[numberOfCharge].y = coord.y
//    }
    func getEquipotential(){
        for y in stride(from: 25.0, to: size.height-25, by: 2){
            for x in stride(from: 25, to: size.width-25, by: 2){
                     if pow(ringNode.position.x - x, 2)
                         + pow(ringNode.position.y - y, 2)
                         <= pow(ringRadius-7,2) ||
                            abs(ringNode.position.x - x) < 30
                {
                         continue
                     }
                     let point: Charge = Charge(x: x, y: y)
                     let potential = abs(field.equipotential(coord: point.vectorCoord()))

                     if
                        10 <= potential && potential <= 11 ||
                        80 <= potential && potential <= 82 ||
                        100 <= potential && potential <= 102 ||
                        200 <= potential && potential <= 202 ||
                        300 <= potential && potential <= 302
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
    
    override func didMove(to view: SKView) {
        ringNode.position = .init(x: size.width/2, y: size.height/2)
        setCharges()
        setRing()
        field.setGameScete(gS: self)
        drawLines()
        setChargesNodes()
        ringNode.removeFromParent()
        self.addChild(ringNode)
    }
    
    
    private var touchedNode: SKNode? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let touchLocation = touch.location(in: self)
        touchedNode = self.atPoint(touchLocation)
        guard let touchedNodeName = touchedNode?.name else {return}
        if touchedNodeName.contains("Ring"){
            removeRingCharges()
            self.removeAllChildren()
            ringCenter = .init(x: 100000, y: 100000)
            drawLines()
            setChargesNodes()
            self.addChild(ringNode)
        } else if touchedNodeName.contains("charge") {
            let touchedNodeNumber = Int(touchedNode!.name!.split(separator: " ")[1])!
            let charge = charges.remove(at: touchedNodeNumber)
            self.removeAllChildren()
            drawLines()
            setChargesNodes()
            charges.insert(charge, at: touchedNodeNumber)
            self.addChild(ringNode)
            self.addChild(touchedNode!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedNode = touchedNode else {return}
        guard let touchedNodeName = touchedNode.name else {return}
        if touchedNodeName.contains("charge"){
            let touchedNodeNumber = Int(touchedNode.name!.split(separator: " ")[1])!
            charges[touchedNodeNumber].x = touchedNode.position.x
            charges[touchedNodeNumber].y = touchedNode.position.y
        } else if touchedNodeName.contains("Ring"){
            updateRingCharges()
        }
        self.touchedNode = nil
        
        self.removeAllChildren()
        drawLines()
        setChargesNodes()
        self.addChild(ringNode)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedNode = touchedNode else {return}
        guard let touchedNodeName = touchedNode.name else {return}
        guard let touch = touches.first else {return}
        let touchLocation = touch.location(in: self)
        if touchedNodeName.contains("charge"){
            touchedNode.position = touchLocation
        } else if touchedNodeName.contains("Ring"){
            ringNode.position = touchLocation
        }
    }
    
    func afterPaused(){
        self.removeAllChildren()
        drawLines()
        setChargesNodes()
        self.addChild(ringNode)
    }
}
