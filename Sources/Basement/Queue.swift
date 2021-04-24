//
//  File.swift
//  
//
//  Created by Samuel Donovan on 11/23/20.
//

import Foundation

class Queue<T> {
    
    class Node {
        var next: Node?
        let payload: T
        
        init(next: Node?, payload: T) {
            self.next = next
            self.payload = payload
        }
    }
    
    var first: Node?
    var last: Node?
    
    var count: Int
    
    init() {
        first = nil
        last = nil
        count = 0
    }
    
    convenience init<S: Sequence>(sequence: S)
    where S.Element == T {
        self.init()
        for s in sequence {
            putLast(s)
        }
    }
    
    func getFirst() -> T? {
        return first?.payload
    }
    
    func removeFirst() {
        if let first = self.first {
            self.first = first.next
            if self.first == nil {last = nil}
            count -= 1
        }
    }
    
    func getAndRemoveFirst() -> T? {
        let first = getFirst()
        removeFirst()
        return first
    }
    
    func putLast(_ element: T) {
        count += 1
        let newLast = Node(next: nil, payload: element)
        if let last = self.last {
            last.next = newLast
            self.last = newLast
        } else {
            self.first = newLast
            self.last = newLast
        }
    }
    
    func isEmpty() -> Bool {count == 0}
}
