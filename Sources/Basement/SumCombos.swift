
fileprivate struct Pair<T: Hashable>: Hashable {
    var first: T
    var second: T
}

class SumCombos {
    private static var cache = [Pair<Int>:Set<MultiSet<Int>>]()
    
    // finds sum combos adding up to n
    public static func findSumCombos(n: Int) -> Set<MultiSet<Int>> {
        guard n > 0 else {return []}
        return findSumCombos(n: n, m: n)
    }
    
    // finds sum combos adding up to n using numbers in 1...m
    private static func findSumCombos(n: Int, m: Int) -> Set<MultiSet<Int>> {
        
        if let cached = cache[Pair(first: n, second: m)] {
            return cached
        }
        
        var combos: Set<MultiSet<Int>> = [[1:n]]
        
        if m <= 1 {return combos}
        
        // for every iteration of the loop, add all sum combos that contain at least 1 i term but no terms greater than i
        for i in 2...m {
            var numI = 1
            while i*numI < n {
                let subCombos = findSumCombos(n: n-i*numI, m: i-1)
                // add j i's to each of these
                for subCombo in subCombos {
                    var withIs = subCombo
                    withIs.insert(i,occurences: numI)
                    combos.insert(withIs)
                }
                
                numI+=1
            }
            if i*numI == n {
                combos.insert([i:numI])
            }
        }
        
        cache[Pair(first: n, second: m)] = combos
        return combos
    }
    
    private static func test0Helper(combos: Set<MultiSet<Int>>, n: Int) -> Bool {
        
        for combo in combos {
            var sum = 0
            for (i,numI) in combo {
                sum += i*numI
            }
            guard n == sum else {return false}
        }
        
        return true
    }
    
    public static func test0() -> Bool {
        for i in 1...100 {
            let combos = findSumCombos(n: i)
            // let success = Self.test0Helper(combos: combos, n: i)
            // guard success else {return false}
            print(combos.count)
        }
        return true
    }
}
