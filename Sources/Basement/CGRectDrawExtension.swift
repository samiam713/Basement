//
//  CGRectDrawExtension.swift
//  
//  Created by Samuel Donovan on 6/25/21.
//

import Foundation
import UIKit

extension CGRect {
    func getX(prop: CGFloat) -> CGFloat {minX + width*prop}
    func getY(prop: CGFloat) -> CGFloat {maxY - height*prop}
    
    func getPoint(x: CGFloat, y: CGFloat) -> CGPoint {CGPoint(x: getX(prop: x), y: getY(prop: y))}
    
    func getPointGeneric<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(x: T, y: U) -> CGPoint {
        return getPoint(x: CGFloat(x), y: CGFloat(y))
    }
}
