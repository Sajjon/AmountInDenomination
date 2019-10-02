//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-02.
//

import Foundation

public struct Denomination {
    let exponent: Int
    let name: String
    init(_ exponent: Int, _ name: String = #function) {
        self.exponent = exponent
        self.name = name
    }
}

public extension Denomination {
    static let minExponent: Int = -18
}

// MARK: - Denomination Presets
public extension Denomination {
    
    static let min = Self.atto
    
    static var atto: Self { .init(Self.minExponent) }
    static var pico: Self { .init(-15) }
    
}

public extension Denomination {
    func expressValueInSmallestPossibleDenomination<M>(value: M) -> M where M: BinaryInteger {
        if exponent == Self.minExponent { return value }
        
        let exponentDelta: Int = abs(Self.minExponent - self.exponent)
        
        let factorInt = Int(pow(Double(10), Double(exponentDelta)))
        let factor = M(factorInt)
        return value * factor
    }
}
