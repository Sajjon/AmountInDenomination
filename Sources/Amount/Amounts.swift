//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-02.
//

import Foundation
import BigInt

public struct UInt256Bound: ValueBound {}
public extension UInt256Bound {
    typealias Magnitude = BigUInt
    static var greatestFiniteMagnitude: Magnitude {
        let pow256 = Magnitude(2).power(256)
        return pow256 - 1
    }
    static var leastNormalMagnitude: Magnitude { 0 }
}

public typealias UInt256 = UnsignedAmount<UInt256Bound>

public struct NonNegativeSupplyBound: ValueBound {}
public extension NonNegativeSupplyBound {
    typealias Magnitude = UInt256.Magnitude
    static var greatestFiniteMagnitude: Magnitude { 21_000_000 }
    static var leastNormalMagnitude: Magnitude { 0 }
}

public struct PositiveSupplyBound: ValueBound {}
public extension PositiveSupplyBound {
    typealias Magnitude = UInt256.Magnitude
    static var greatestFiniteMagnitude: Magnitude { 21_000_000 }
    static var leastNormalMagnitude: Magnitude { 1 }
}

public typealias NonNegativeSupply = UnsignedAmount<NonNegativeSupplyBound>
public typealias PositiveSupply = UnsignedAmount<PositiveSupplyBound>

public struct Int256Bound: ValueBound {}
public extension Int256Bound {
    typealias Magnitude = BigUInt
    static var greatestFiniteMagnitude: Magnitude { Magnitude(2).power(255) - 1 }
    static var leastNormalMagnitude: Magnitude { greatestFiniteMagnitude }
}

public typealias Int256 = SignedAmount<Int256Bound>
