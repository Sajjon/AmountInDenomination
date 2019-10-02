//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-02.
//

import Foundation

public struct SignedAmount<Bound>: SignedAmountType where Bound: ValueBound {
 
    public typealias Magnitude = Bound.Magnitude
    
    public enum Sign {
        case plus
        case minus
    }
        
    /// The absolute value of this integer. `magnitude` is measured in smallest possible `Denomination` (`Denomination.minExponent`)
    public let magnitude: Magnitude
    
    /// True iff the value of this integer is negative.
    public private(set) var sign: Sign
    
    /// Initializes a new signed amount with the provided absolute number and sign flag.
    public init(sign: Sign, magnitude: Magnitude, denomination: Denomination = .atto) throws {
        let valueInSmallestDenomination = denomination.expressValueInSmallestPossibleDenomination(value: magnitude)
        try Bound.contains(value: valueInSmallestDenomination)
        self.magnitude = valueInSmallestDenomination

        self.sign = (magnitude.isZero ? .plus : sign)
    }
}

private extension SignedAmount {
    init(magnitudeFromArithmetic: Magnitude, sign: Sign) {
        do {
            try self.init(sign: sign, magnitude: magnitudeFromArithmetic)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}

// MARK: - Typealiases
public extension SignedAmount {
    typealias Words = Bound.Magnitude.Words
    typealias IntegerLiteralType = Bound.Magnitude.IntegerLiteralType
}

// MARK: - Signed
public extension SignedAmount {
    static var isSigned: Bool { true }
    
    /// Return true iff this integer is zero.
    ///
    /// - Complexity: O(1)
    var isZero: Bool {
        return magnitude.isZero
    }
    
    /// Returns `-1` if this value is negative and `1` if it’s positive; otherwise, `0`.
    ///
    /// - Returns: The sign of this number, expressed as an integer of the same type.
    func signum() -> Self {
        switch sign {
        case .plus:
            return isZero ? 0 : 1
        case .minus:
            return -1
        }
    }
}

public extension SignedAmount {
    mutating func negate() {
        guard !magnitude.isZero else { return }
        self.sign = self.sign == .plus ? .minus : .plus
    }
    
    /// Subtract `b` from `a` and return the result.
    static func - (a: Self, b: Self) -> Self {
        return a + -b
    }
    
    /// Subtract `b` from `a` in place.
    static func -= (a: inout Self, b: Self) { a = a - b }
}


public extension SignedAmount {
    var bitWidth: Int {
        guard !magnitude.isZero else { return 0 }
        return magnitude.bitWidth + 1
    }
    
    var trailingZeroBitCount: Int { magnitude.trailingZeroBitCount }
}

public extension SignedAmount {
    /// Return true iff `a` is equal to `b`.
    static func == (a: Self, b: Self) -> Bool {
        return a.sign == b.sign && a.magnitude == b.magnitude
    }
    
    /// Return true iff `a` is less than `b`.
    static func < (a: Self, b: Self) -> Bool {
        switch (a.sign, b.sign) {
        case (.plus, .plus):
            return a.magnitude < b.magnitude
        case (.plus, .minus):
            return false
        case (.minus, .plus):
            return true
        case (.minus, .minus):
            return a.magnitude > b.magnitude
        }
    }
}

extension SignedAmount: Hashable {
    /// Append this `SignedAmount` to the specified hasher.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sign)
        hasher.combine(magnitude)
    }
}

public extension SignedAmount {
    /// Add `a` to `b` and return the result.
    static func + (a: Self, b: Self) -> Self {
        switch (a.sign, b.sign) {
        case (.plus, .plus):
            return Self(magnitudeFromArithmetic: a.magnitude + b.magnitude, sign: .plus)
        case (.minus, .minus):
            return Self(magnitudeFromArithmetic: a.magnitude + b.magnitude, sign: .minus)
        case (.plus, .minus):
            if a.magnitude >= b.magnitude {
                return Self(magnitudeFromArithmetic: a.magnitude - b.magnitude, sign: .plus)
            }
            else {
                return Self(magnitudeFromArithmetic: b.magnitude - a.magnitude, sign: .minus)
            }
        case (.minus, .plus):
            if b.magnitude >= a.magnitude {
                return Self(magnitudeFromArithmetic: b.magnitude - a.magnitude, sign: .plus)
            }
            else {
                return Self(magnitudeFromArithmetic: a.magnitude - b.magnitude, sign: .minus)
            }
        }
    }
    
    /// Add `b` to `a` in place.
    static func +=(a: inout Self, b: Self) {
        a = a + b
    }
}

public extension SignedAmount {
    /// Multiply `a` with `b` and return the result.
    static func *(a: Self, b: Self) -> Self {
        return Self(magnitudeFromArithmetic: a.magnitude * b.magnitude, sign: a.sign == b.sign ? .plus : .minus)
    }
    
    /// Multiply `a` with `b` in place.
    static func *= (a: inout Self, b: Self) { a = a * b }
}
