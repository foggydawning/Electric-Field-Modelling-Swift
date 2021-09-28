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
    var dim: Int = 2
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

class InteractionField{
    var points: [Point] = []
    
    func F(p1: Point, p2: Point, distance: Double) -> Double {
        ( 300000 * (-1.0) * p1.q * p2.q ) / (pow(distance, 2) + 0.1)
    }
    
    func intensity(coord: Vector) -> Vector{
        var proj = Vector(x: 0, y: 0)
        let single_point = Point(x: 0, y: 0)
        for point in self.points{
            let pointCoordinate = point.vectorCoord()
            if coord.mod(pointCoordinate) < pow(10, -10){
                continue
            }
            let dif = pointCoordinate.mod(coord)
            let fmod = self.F(p1: single_point,
                              p2: Point(x: pointCoordinate.x, y: pointCoordinate.y, q: point.q),
                              distance: dif) * (-1)
            proj = coord.diff(pointCoordinate).div(dif).mult(fmod).add(proj)
        }
        return proj
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
