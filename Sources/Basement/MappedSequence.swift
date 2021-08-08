struct MappedSequence<T:Sequence,U>: Sequence {
    __consuming func makeIterator() -> MappedIterator {
        return MappedIterator(f: f, current: start)
    }

    typealias Iterator = MappedIterator
    typealias Element = U
    
    let start: T.Iterator
    let f: (T.Element)->U
    
    init(sequence: T, f: @escaping (T.Element)->U) {
        self.start = sequence.makeIterator()
        self.f = f
    }
    
    struct MappedIterator: IteratorProtocol {
        
        typealias Element = U
        
        let f: (T.Element)->U
        var current: T.Iterator
        
        mutating func next() -> U? {
            guard let next = current.next() else {return nil}
            return f(next)
        }
    }
}
