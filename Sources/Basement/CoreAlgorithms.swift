//
//  File 2.swift
//  
//
//  Created by Samuel Donovan on 9/19/20.
//

import Foundation

// from swift-algorithm-club
func gcd(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)
    
    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

// because {gcd($0,$1)*lcm($0,$1)==$0*$1}
func lcm(_ m: Int, _ n: Int) -> Int {(m/gcd(m, n))*n}

// from https://stackoverflow.com/questions/101439/the-most-efficient-way-to-implement-an-integer-based-power-function-powint-int/101613#101613
func power(base: Int, exponent: Int) -> Int {
    guard exponent > 0 else {return 1}
    var base = base
    var exponent = exponent
    var result = 1
    
    while true
    {
        if (exponent & 1 == 1) {result *= base}
        exponent >>= 1
        if (exponent == 0) {break}
        base *= base
    }
    
    return result;
}

