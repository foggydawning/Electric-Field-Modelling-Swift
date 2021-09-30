//
//  PhysicalObjects.swift
//  Electric Field Modelling
//
//  Created by Илья Чуб on 27.09.2021.
//

import Foundation
import UIKit

class Vector{
    var x: Double
    var y: Double
    var coord: CGPoint{
        CGPoint(x: x, y: y)
    }
    
    init(x: Double, y: Double){
        self.x = x
        self.y = y
    }
    
    func add(_ secondVector: Vector) -> Vector{
        let new_x = self.x + secondVector.x
        let new_y = self.y + secondVector.y
        return Vector(x: new_x, y: new_y)
    }
    
    func diff(_ secondVector: Vector) -> Vector{
        let new_x = self.x - secondVector.x
        let new_y = self.y - secondVector.y
        return Vector(x: new_x, y: new_y)
    }
    
    func mult(_ number: Double) -> Vector{
        let new_x = self.x * number
        let new_y = self.y * number
        return Vector(x: new_x, y: new_y)
    }
    
    func div(_ number: Double) -> Vector{
        let new_x = self.x / number
        let new_y = self.y / number
        return Vector(x: new_x, y: new_y)
    }
    
    func mod(_ secondVector: Vector) -> Double{
        pow(
            pow( (self.x-secondVector.x), 2)
            + pow( (self.y-secondVector.y), 2),
            0.5
        )
    }
    
    func module() -> Double{
        sqrt(pow(x, 2) + pow(y, 2))
    }
}

class Point{
    var x, y, q: Double

    func vectorCoord() -> Vector{
        Vector(x: x, y: y)
    }
    
    init(x: Double, y: Double, q: Double = 1){
        self.x = x
        self.y = y
        self.q = q
    }
    
    func CGPCoord() -> CGPoint{
        CGPoint(x: self.x, y: self.y)
    }
}

class Ring{
    var outerRadius, width: Double
    var center: CGPoint
    var innerRadius: Double {
        outerRadius - width
    }
    
    init(center: CGPoint, outerRadius: Double, width: Double){
        self.center = center
        self.outerRadius = outerRadius
        self.width = width
    }
}


class InteractionField{
    private var points: [Point] = []
    
    func F(p1: Point, distance: Double) -> Double {
        p1.q / (pow(distance, 2) + 0.0001)
    }
    
    func intensity(coord: Vector) -> Vector{
        var inten: Vector = Vector(x: 0, y: 0)
        for point in self.points{
            let pointCoordinates = point.vectorCoord()
            if coord.mod(pointCoordinates) < pow(10, -10){
                continue
            }
            let dif = pointCoordinates.mod(coord)
            let fmod = self.F(p1: point,
                              distance: dif)
            inten = coord
                .diff(pointCoordinates)
                .div(dif)
                .mult(fmod)
                .add(inten)
        }
        return inten
    }
    
    func equipotential(coord: Vector) -> Double{
        var potencial: Double = 0
        for point in self.points{
            let pointCoordinates = point.vectorCoord()
            let dif = pointCoordinates.mod(coord)
            potencial += point.q / (dif + 0.0001) * 1000
        }
        return potencial
    }
    
    func setPoints(points: [Point]) {
        for point in points{
            self.points.append(point)
        }
    }
    
    func resetPoints(points: [Point]) {
        self.points = []
        setPoints(points: points)
    }
}
