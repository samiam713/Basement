import Foundation

struct MultiSet<T: Hashable>: ExpressibleByDictionaryLiteral, Hashable, CustomStringConvertible {
    typealias Key = T
    typealias Value = Int
    
    /// key to positive number of occurences
    var d = [T:Int]()
    
    var description: String {d.description}
    
    init(dictionaryLiteral elements: (T, Int)...) {
        for (element,occurences) in elements {self[element] = occurences}
    }
    
    mutating func insert(_ value: T, occurences: Int = 1) {
        if let old = d[value] {d[value] = old + occurences}
        else {d[value] = occurences}
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

extension MultiSet: Sequence {
    func makeIterator() -> Dictionary<T,Int>.Iterator {d.makeIterator()}
}
