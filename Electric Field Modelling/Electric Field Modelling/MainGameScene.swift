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

class MainGameScene: SKScene, ElFieldModelMainScene{
    var charges: [Charge] = [Charge(x: 100, y: 100, q: 1),
                             Charge(x: 100, y: 200, q: 1),
                             Charge(x: 100, y: 300, q: 1),
                             Charge(x: 100, y: 400, q: 1),
                             Charge(x: 100, y: 500, q: 1),
                             Charge(x: 100, y: 600, q: 1),
                                                      Charge(x: 1000, y: 100, q: -1),
                                                      Charge(x: 1000, y: 200, q: -1),
                                                      Charge(x: 1000, y: 300, q: -1),
                                                      Charge(x: 1000, y: 400, q: -1),
                                                      Charge(x: 1000, y: 500, q: -1),
                                                      Charge(x: 1000, y: 600, q: -1),
                             ]
    var field = InteractionField()
    var chargeRadius: CGFloat = 20
    var lastModule: Int = 0
    
    func setChargesNodes(){
        var number: Int = 0
        for charge in charges {
            let node = SKShapeNode(circleOfRadius: chargeRadius)
            node.position = charge.CGPCoord()
            node.fillColor = .red
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
        
        while 0 <= x &&
                x < size.width &&
                y >= 0 &&
                y < size.height{
            var inten = field.intensity(coord: Vector(x: x, y: y))
            inten = inten
                .div( inten.mod( Vector(x: 0, y: 0)) * 0.03)
            
            let startPoint = CGPoint(x: Double(round(x) ), y: Double(round(y)))
            let endPoint = CGPoint(x: Double(round(x+inten.x) ), y: Double(round(y + inten.y)))
            
            if endPoint == lastPoint ||
                abs(endPoint.x-lastLine[0].x) < 10 {
//                print(0)
                break
            }
            var points: [CGPoint] = [startPoint, endPoint]
//            print(points)
            
            let line = SKShapeNode(points: &points, count: 2)
            
//            lastModule = pow(pow(points[0],2) + pow(points[1],2), 0.5)
            
            self.addChild(line)
            
            lastPoint = CGPoint(x: x, y: y)
            lastLine = points
            x = endPoint.x
            y = endPoint.y
        }
    }

    func drawLines(){
        for x in stride(from: 50.0, to: size.width-50, by: 40){
            for y in stride(from: 50.0, to: size.height-50, by: 40){
                if x == 0 || y == 0{
                    continue
                }
                drawLine(x: Double(x), y: Double(y))
            }
        }
        
    }
    
    func changeChargesCoordinate(numberOfCharge: Int, coord: CGPoint){
        charges[numberOfCharge].x = coord.x
        charges[numberOfCharge].y = coord.y
    }
    
    override func didMove(to view: SKView) {
        field.setGameScete(gS: self)
        drawLines()
        setChargesNodes()
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.removeAllChildren()
        drawLines()
        setChargesNodes()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        guard let touchedNodeName = touchedNode.name else {return}
        let touchedNodeNumber = Int(touchedNode.name!.split(separator: " ")[1])!
        if touchedNodeName.contains("charge"){
            touchedNode.position = touchLocation
        }
        charges[touchedNodeNumber].x = touchedNode.position.x
        charges[touchedNodeNumber].y = touchedNode.position.y
    }
    
    
}
