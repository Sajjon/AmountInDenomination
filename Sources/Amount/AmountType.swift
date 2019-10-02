//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-02.
//

import Foundation


public protocol AmountTrait {}
public struct NoTrait: AmountTrait {}
public struct GranularityAmountTrait: AmountTrait {}
public struct TokenAmountTrait: AmountTrait {}
public struct SupplyAmountTrait: AmountTrait {}


public protocol AmountType: BinaryInteger where Bound.Magnitude == Self.Magnitude {
    associatedtype Bound: ValueBound
    associatedtype Trait: AmountTrait
    var denomination: Denomination { get } // hard code to Denomination.min
    init(magnitude: Magnitude, denomination: Denomination) throws
}

public protocol UnsignedAmountType: AmountType & UnsignedInteger {}
