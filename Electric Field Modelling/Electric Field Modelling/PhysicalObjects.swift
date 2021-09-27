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
    
    init(x: Double, y: Double){
        self.x = x
        self.y = y
    }
    
    func add(secondVector: Vector) -> Vector{
        let new_x = self.x + secondVector.x
        let new_y = self.y + secondVector.y
        return Vector(x: new_x, y: new_y)
    }
    
    func diff(secondVector: Vector) -> Vector{
        let new_x = self.x - secondVector.x
        let new_y = self.y - secondVector.y
        return Vector(x: new_x, y: new_y)
    }
    
    func mod(secondVector: Vector) -> Double{
        pow(
            pow( (self.x-secondVector.x), 2)
            + pow( (self.y-secondVector.y), 2),
            0.5
        )
    }
}

class Point{
    var x, y, q, mass: Double
    
    var coord: CGPoint {
        CGPoint(x: x, y: y)
    }
    
    init(x: Double, y: Double, q: Double = 1, mass: Double = 1){
        self.x = x
        self.y = y
        self.q = q
        self.mass = mass
    }
}
