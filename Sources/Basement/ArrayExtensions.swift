//
//  File.swift
//  
//
//  Created by Samuel Donovan on 9/12/20.
//

import Foundation

extension Array where Element: Equatable {
    mutating func unsafeRemove(element: Element) {
        self.remove(at: self.firstIndex(of: element)!)
    }
}

extension Array {
    
    func attemptMap<T>(unsafe: (Element) -> T?) -> [T]? {
        var newArray = [T]()
        newArray.reserveCapacity(self.count)
        for index in self.indices {
            guard let newElement = unsafe(self[index]) else {return nil}
            newArray.append(newElement)
        }
        return newArray
    }
}

extension Sequence {
    // Swift library already has this LOL
    // min(by: (Element,Element) -> Bool) -> Element?
    func findExtremum(useFirst: (Element,Element) -> Bool) -> Element? {
        
        var iterator = self.makeIterator()
        guard var current = iterator.next() else {return nil}
        
        while let potential = iterator.next() {
            if useFirst(potential,current) {
                current = potential
            }
        }
        
        return current
    }
}
