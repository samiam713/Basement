//
//  File.swift
//  
//
//  Created by Samuel Donovan on 8/8/21.
//

import Dispatch

enum OrPair<T,U> {
    case first(T)
    case second(U)
}

/// Used to deal with the result of an asynchronous operation
/// The asynchronous operator calls fulfill when the operation is complete, which triggers events in other threads
class Promise<T> {
    
    static func ||<U>(lhs: Promise, rhs: Promise<U>) -> Promise<OrPair<T,U>> {return lhs.or(other: rhs)}
    static func &&<U>(lhs: Promise, rhs: Promise<U>) -> Promise<(T,U)> {return lhs.and(other: rhs)}
    
    enum PromiseOptional {
        case some(T)
        case none
        
        func isNone() -> Bool {
            switch self {
            case .none:
                return true
            case .some(_):
                return false
            }
        }
    }
    
    private let queue = DispatchQueue(label: "PromiseQueue")
    var callbacks = [(T)->()]()
    var result: PromiseOptional = .none
    
    /// called by asynchronous operator upon completing operation
    func fulfill(_ object: T) {
        queue.sync {
            guard self.result.isNone() else {return}
            self.result = .some(object)
            for callback in self.callbacks {
                callback(object)
            }
            self.callbacks.removeAll()
        }
    }
    
    /// blocks until the promise is fulfilled
    func wait() -> T {
        let group = DispatchGroup()
        var result: PromiseOptional = .none
        group.enter()
        
        queue.sync {
            switch result {
            case .some(let object):
                self.result = .some(object)
                group.leave()
            case .none:
                self.addUnsafe() {(object: T) in
                    result = .some(object)
                    group.leave()
                }
            }
        }
        
        group.wait()
        
        switch result {
        case .none: fatalError()
        case .some(let object): return object
        }
    }
    
    private func addUnsafe(callback: @escaping (T) -> ()) {
        switch self.result {
        case .some(let object):
            callback(object)
        case .none:
            self.callbacks.append(callback)
        }
    }
    
    func add(callback: @escaping (T) -> ()) {
        queue.sync {addUnsafe(callback: callback)}
    }
    
    func and<U>(other: Promise<U>) -> Promise<(T,U)> {
        let promise = Promise<(T,U)>()
        
        DispatchQueue.global().async {
            let result1 = self.wait()
            let result2 = other.wait()
            promise.fulfill((result1,result2))
        }
        
        return promise
    }
    
    
    func or<U>(other: Promise<U>) -> Promise<OrPair<T,U>> {
        let promise = Promise<OrPair<T,U>>()
        let semaphore = DispatchSemaphore(value: 1)
        var completed = false
        
        add() {(object: T) in
            semaphore.wait()
            defer {semaphore.signal()}
            
            if completed {return}; completed = true
            
            promise.fulfill(.first(object))
        }
        
        other.add() {(object: U) in
            semaphore.wait()
            defer {semaphore.signal()}
            
            if completed {return}; completed = true
            
            promise.fulfill(.second(object))
        }
        
        return promise
    }
    
    func map<U>(transform: @escaping (T) -> U) -> Promise<U> {
        let promise = Promise<U>()
        
        add() {(t: T) in
            promise.fulfill(transform(t))
        }
        
        return promise
    }
}

extension Promise where T == DispatchTimeInterval {
    static func timer(seconds: DispatchTimeInterval, qos: DispatchQoS.QoSClass = .default) -> Promise {
        let promise = Promise()
        let now1 = DispatchTime.now()
        
        DispatchQueue.global(qos: qos).asyncAfter(deadline: .now()+seconds) {
            let now2 = DispatchTime.now()
            let timeInterval = DispatchTimeInterval.nanoseconds(Int(now2.uptimeNanoseconds - now1.uptimeNanoseconds))
            
            promise.fulfill(timeInterval)
        }
        
        return promise
    }
}
