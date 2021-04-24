//
//  File.swift
//  
//
//  Created by Samuel Donovan on 4/23/21.
//

import Foundation

class Neuron: Hashable {
    
    var id: ObjectIdentifier {ObjectIdentifier(self)}
    
    public static func ==(lhs: Neuron, rhs: Neuron) ->Bool {lhs.id == rhs.id}
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func startFiring() {
        isFiring = true
        for parent in parents {
            parent.childStartedFiring(child: self)
        }
    }
    
    func stopFiring() {
        isFiring = false
        for parent in parents {
            parent.childStoppedFiring(child: self)
        }
    }
    
    // if already not, return original.
    // otherwise, lazily generate not
    // func getNot()
    
    func deleteFromParents() {
        for parent in parents {
            parent.remove(child: self)
        }
    }
    
    var isFiring: Bool = false
    var parents = Set<TreeNeuron>()
    
    // GOTTA IMPLEMENT THIS
    var _negation: NotNeuron? = nil
    func negation() -> Neuron {
        if let self = self as? NotNeuron {return self.negating}
        
        let negation = NotNeuron(negating: self)
        _negation = negation
        return negation
    }
}

class ParentNeuron: Neuron {
    func childStartedFiring(child: Neuron) {fatalError()}
    func childStoppedFiring(child: Neuron) {fatalError()}
}

class TreeNeuron: ParentNeuron {
    
    func add(child: Neuron) {fatalError()}
    // var children: Set<WChildNeuron> {get set}
    
    func remove(child: Neuron) {fatalError()}
    
    var firingChildren = Set<Neuron>()
    var nonFiringChildren = Set<Neuron>()
}

class AndNeuron: TreeNeuron {
    
    override init() {
        super.init()
        isFiring = true
    }
    
    override func childStartedFiring(child: Neuron) {
        nonFiringChildren.remove(child)
        firingChildren.insert(child)
        
        if nonFiringChildren.isEmpty {startFiring()}
    }
    
    override func childStoppedFiring(child: Neuron) {
        firingChildren.remove(child)
        nonFiringChildren.insert(child)
        
        if isFiring {stopFiring()}
    }
    
    override func add(child: Neuron) {
        if child.isFiring {
            firingChildren.insert(child)
        } else {
            nonFiringChildren.insert(child)
            if isFiring {stopFiring()}
        }
    }
    
    override func remove(child: Neuron) {
        if child.isFiring {
            firingChildren.remove(child)
        } else {
            nonFiringChildren.remove(child)
            if nonFiringChildren.isEmpty {startFiring()}
        }
    }
}
class OrNeuron: TreeNeuron {
    override func childStartedFiring(child: Neuron) {
        nonFiringChildren.remove(child)
        firingChildren.insert(child)
        
        if !isFiring {startFiring()}
    }
    
    override func childStoppedFiring(child: Neuron) {
        firingChildren.remove(child)
        nonFiringChildren.insert(child)
        
        if firingChildren.isEmpty {stopFiring()}
    }
    
    override func add(child: Neuron) {
        if child.isFiring {
            firingChildren.insert(child)
            if !isFiring {startFiring()}
        } else {
            nonFiringChildren.insert(child)
        }
    }
    
    override func remove(child: Neuron) {
        if child.isFiring {
            firingChildren.remove(child)
            if !nonFiringChildren.isEmpty {
                startFiring()
            }
        } else {
            nonFiringChildren.remove(child)
        }
    }
}

class NotNeuron: ParentNeuron {
    let negating: Neuron
    
    init(negating: Neuron) {
        self.negating = negating
        super.init()
        self.isFiring = !negating.isFiring
    }
    
    override func childStartedFiring(child: Neuron) {
        stopFiring()
    }
    override func childStoppedFiring(child: Neuron) {
        startFiring()
    }
}

// implement me
class NeuralNetwork {
    
    var neurons: Set<Neuron> = []
    
    func create(neuron: Neuron) {
        neurons.insert(neuron)
    }
    
    func delete(neuron: Neuron) {
        neurons.remove(neuron)
        neuron.deleteFromParents()
        
        if let negation = neuron._negation {
            neurons.remove(negation)
            negation.deleteFromParents()
        }
    }
}

