//
//  File.swift
//  
//
//  Created by Samuel Donovan on 4/23/21.
//

import Foundation

class UndirectedGraph<T>: Sequence where T: Hashable {
    
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
        
        for outgoingNode in data[node]! {
            data[outgoingNode]!.remove(node)
        }
        
        data[node] = nil

    }
    
    // Assumes graph contains nodes
    func add(node0: T, node1: T) {
        data[node0]!.insert(node1)
        data[node1]!.insert(node0)
    }
    
    // Assumes graph contains nodes
    func remove(node0: T, node1: T) {
        data[node1]!.remove(node0)
        data[node0]!.remove(node1)
    }
    
}
