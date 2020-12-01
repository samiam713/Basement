//
//  File.swift
//  
//
//  Created by Samuel Donovan on 12/1/20.
//

import Foundation

class Graph<T>: Sequence where T: Hashable {
    
    func makeIterator() -> Dictionary<T, Set<T>>.Iterator {data.makeIterator()}
    
    var data = [T:Set<T>]()
    
    func contains(node: T) -> Bool {data[node] != nil}
    func getChildren(of: T) -> Set<T> {data[of]!}
    
    // Assumes graph does not contain node
    func add(node: T) {
        data[node] = []
    }
    
    // Assumes graph contains node
    func remove(node: T) {
        data[node] = nil
        
        var hasReferenceSeq = [T]()
        for (parent, children) in data {
            if children.contains(node) {
                hasReferenceSeq.append(parent)
            }
        }
        
        for hasReference in hasReferenceSeq {
            data[hasReference]!.remove(node)
        }
    }
    
    // Assumes graph contains node
    func add(child: T, to: T) {
        data[to]!.insert(child)
    }
    
    // Assumes graph contains node
    func remove(child: T, to: T) {
        data[to]!.remove(child)
    }
    
}
