//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-02.
//

import Foundation

public protocol MagnitudeType: BinaryInteger {
    var isZero: Bool { get }
}

public protocol ValueBound where Magnitude.Magnitude == Magnitude {
    associatedtype Magnitude: MagnitudeType
    static var isSigned: Bool { get }
    
    /// Greatest possible magnitude measured in the smallest possible `Denomination` (`Denomination.minExponent`)
    static var greatestFiniteMagnitude: Magnitude { get }
    
    /// Smallest possible magnitude measured in the smallest possible `Denomination` (`Denomination.minExponent`)
    static var leastNormalMagnitude: Magnitude { get }
    
    static func contains(value: Magnitude) throws
}

public enum ValueError: Swift.Error, Equatable {
    case valueTooBig
    case valueTooSmall
}

public extension ValueBound {
    static var isSigned: Bool { Magnitude.isSigned }
    static func contains(value: Magnitude) throws {
        if value > Self.greatestFiniteMagnitude { throw ValueError.valueTooBig }
        if value < Self.leastNormalMagnitude { throw ValueError.valueTooSmall }
        // all is well
    }
}
