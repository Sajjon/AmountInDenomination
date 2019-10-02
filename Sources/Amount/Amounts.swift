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

public typealias UInt256 = UnsignedAmount<UInt256Bound, NoTrait>

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

public typealias NonNegativeSupply = UnsignedAmount<NonNegativeSupplyBound, SupplyAmountTrait>
public typealias PositiveSupply = UnsignedAmount<PositiveSupplyBound, SupplyAmountTrait>

public protocol ValueBoundWhichIsSubsetOfOther: ValueBound where Self.Magnitude == Superset.Magnitude {
    associatedtype Superset: ValueBound
}
public extension ValueBoundWhichIsSubsetOfOther {
    
    static var greatestFiniteMagnitude: Magnitude { Superset.greatestFiniteMagnitude }
    
    static var leastNormalMagnitude: Magnitude { Superset.leastNormalMagnitude }
}

public struct UInt256NonZeroBound: ValueBoundWhichIsSubsetOfOther {}
public extension UInt256NonZeroBound {
    typealias Superset = UInt256Bound
    typealias Magnitude = Superset.Magnitude
    static var leastNormalMagnitude: Magnitude { 1 }
}

public typealias UInt256NonZero = UnsignedAmount<UInt256NonZeroBound, NoTrait>

public extension UnsignedAmountType where Bound: ValueBoundWhichIsSubsetOfOther {
    init<Other>(other: Other) where Other: UnsignedAmountType, Self.Bound.Superset == Other.Bound, Other.Trait == Self.Trait {
        do {
            try self.init(magnitude: other.magnitude, denomination: other.denomination)
        } catch {
            incorrectImplementationShouldAlwaysBeAble(to: "Create from Other if `Bound: ValueBoundWhichIsSubsetOfOther`", error)
        }
    }
}

internal func incorrectImplementation(
    _ reason: String? = nil,
    _ file: String = #file,
    _ line: Int = #line
) -> Never {
    let reasonString = reason != nil ? "`\(reason!)`" : ""
    let message = "Incorrect implementation: \(reasonString),\nIn file: \(file), line: \(line)"
    fatalError(message)
}

internal func incorrectImplementationShouldAlwaysBeAble(
    to reason: String,
    _ error: Swift.Error? = nil,
    _ file: String = #file,
    _ line: Int = #line
) -> Never {
    let errorString = error.map { ", error: \($0) " } ?? ""
    incorrectImplementation("Should always be to: \(reason)\(errorString)")
}
