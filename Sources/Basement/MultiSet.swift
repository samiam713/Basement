//
//  File.swift
//  
//
//  Created by Samuel Donovan on 4/17/21.
//

import Foundation

struct MultiSet<T: Hashable>: ExpressibleByDictionaryLiteral {
    typealias Key = T
    typealias Value = Int
    
    var d = [T:Int]()
    
    init(dictionaryLiteral elements: (T, Int)...) {
        for (element,occurences) in elements {self[element] = occurences}
    }
    
    mutating func insert(_ value: T) {
        if let old = d[value] {d[value] = old + 1}
        else {d[value] = 1}
    }
    
    mutating func remove(_ value: T) {
        guard let old = d[value] else {return}
        if old == 1 {d[value] = nil}
        else {d[value] = old - 1}
    }
    
    func contains(_ value: T) -> Bool {d[value] != nil}
    
    func occurences(_ value: T) -> Int {d[value] ?? 0}
    
    subscript(_ value: T) -> Int {
        get {return occurences(value)}
        
        set(newValue) {
            if newValue > 0 {d[value] = newValue}
            else {d[value] = nil}
        }
    }
}
