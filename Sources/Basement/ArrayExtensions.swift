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
