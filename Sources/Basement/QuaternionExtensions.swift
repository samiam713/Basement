//
//  File.swift
//  
//
//  Created by Samuel Donovan on 1/22/21.
//

import Foundation
import simd

func toRadians<T: BinaryFloatingPoint>(_ degrees: T) -> T {degrees*(T.pi/180.0)}
func toDegrees<T: BinaryFloatingPoint>(_ radians: T) -> T {radians*(180.0/T.pi)}

extension simd_quatf {
    
    static let identity = Self.init(angle: 0, axis: [1,0,0])
    
    func rotationInXZ() -> simd_quatf {
        let rotated = self.act([0,0,-1])
        
        var xzVector = SIMD2<Float>(-rotated.z, -rotated.x)
        guard xzVector != .zero else {return .identity}
        xzVector = simd_normalize(xzVector)
        
        var angle: Float
        
        switch xzVector.x {
        case let x where x > 0.9999:
            angle = 0
        case let x where ((-0.0001)...(0.0001)).contains(x) :
            if xzVector.y < 0 {
                angle = .pi * 0.5
            } else {
                angle = -0.5 * Float.pi
            }
        case let x where x < -0.9999:
            angle = .pi
        case let x where x > 0:
            angle = atan(xzVector.y/xzVector.x)
        case let x where x < 0:
            angle = .pi + atan(xzVector.y/xzVector.x)
        default:
            fatalError()
        }
        
        return .init(angle: angle, axis: [0,1,0])
    }
}
