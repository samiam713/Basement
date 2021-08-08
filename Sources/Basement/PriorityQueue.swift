//
//  File.swift
//  
//
//  Created by Samuel Donovan on 11/23/20.
//

import Foundation

class PriorityQueue<T> {
    
    class Node {
        let payload: T
        var next: Node?
        
        init(payload: T, next: Node?) {
            self.payload = payload
            self.next = next
        }
    }
    
    // (node,node.next) satisfies this
    let orderPredicate: (T,T) -> Bool
    
    var head: Node?
    var tail: Node?
    var count: Int
    
    init(orderPredicate: @escaping (T, T) -> Bool) {
        self.orderPredicate = orderPredicate
        self.head = nil
        self.tail = nil
        self.count = 0
    }
    
    func insert(_ element: T) {
        
        count += 1
        
        // deal with case list isn't empty
        if var current = head {
            
            // check if goes first
            if orderPredicate(element, head!.payload) {
                head = Node(payload: element, next: head!)
            }
            
            // if should go last, insert
            if orderPredicate(tail!.payload, element) {
                let newItem = Node(payload: element, next: nil)
                tail!.next = newItem
                tail = newItem
            }
            
            // if shouldn't go first or last, find where in the middle it goes
            while !orderPredicate(current.payload, element) {
                current = current.next!
            }
            
            let newItem = Node(payload: element, next: current.next)
            current.next = newItem
        }
        
        // deal with case list is empty
        let newItem = Node(payload: element, next: nil)
        head = newItem
        tail = newItem
    }
    
    func getFirst() -> T? {
        return head?.payload
    }
    
    func removeFirst() {
        if let head = head {
            self.head = head.next
            if self.head == nil {
                tail = nil
            }
            count -= 1
        }
    }
    
    func isEmpty() -> Bool {count == 0}
    
}
