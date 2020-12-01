//
//  File.swift
//  
//
//  Created by Samuel Donovan on 12/1/20.
//

import Foundation

struct BoolArray64 {
    var data: UInt64 = 0
    
    subscript(_ i: Int) -> Bool {
        get {return (data >> i)&1 == 1}
        
        set(newValue) {
            let currentValue = (data >> i)&1
            
            // if current value isn't what it should be, flip bit
            if currentValue != (newValue ? 1 : 0) {
                data ^= (1<<i)
            }
        }
    }
}
