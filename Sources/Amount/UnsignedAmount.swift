import Foundation
import BigInt

extension BigUInt: MagnitudeType {
    public var isZero: Bool {
        return signum() == 0
    }
}
extension BigInt: MagnitudeType {}

public struct UnsignedAmount<Bound, Trait>: UnsignedAmountType where Bound: ValueBound, Trait: AmountTrait {
 
    public typealias Magnitude = Bound.Magnitude
    
    /// `magnitude` measured in smallest possible `Denomination` (`Denomination.minExponent`)
    public let magnitude: Magnitude
        
    public init(magnitude: Magnitude, denomination: Denomination = .atto) throws {
        let valueInSmallestDenomination = denomination.expressValueInSmallestPossibleDenomination(value: magnitude)
        try Bound.contains(value: valueInSmallestDenomination)
        self.magnitude = valueInSmallestDenomination
    }
}

// MARK: - Typealiases
public extension UnsignedAmount {
    typealias Words = Bound.Magnitude.Words
    typealias IntegerLiteralType = Bound.Magnitude.IntegerLiteralType
}

public extension UnsignedAmount {
    var denomination: Denomination { .min }
}

// MARK: - Numeric Init
public extension UnsignedAmount {
    
    init?<T>(exactly source: T) where T: BinaryInteger {
        guard let fromSource = Magnitude(exactly: source) else { return nil }
        try? self.init(magnitude: fromSource)
    }
}

// MARK: - Numeric Operators
public extension UnsignedAmount {
    
    /// Multiplies two values and produces their product.
    static func * (lhs: Self, rhs: Self) -> Self {
        return calculate(lhs, rhs, operation: *)
    }
    
    /// Adds two values and produces their sum.
    static func + (lhs: Self, rhs: Self) -> Self {
        return calculate(lhs, rhs, operation: +)
    }
    
    /// Subtracts one value from another and produces their difference.
    static func - (lhs: Self, rhs: Self) -> Self {
        return calculate(lhs, rhs,
                         willOverflowIf: rhs > lhs,
                         operation: -)
    }
}

// MARK: - Comparable
public extension UnsignedAmount {

    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.magnitude < rhs.magnitude
    }
    
    static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.magnitude > rhs.magnitude
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.magnitude == rhs.magnitude
    }
}

// MARK: - Numeric Operators Inout
public extension UnsignedAmount {
    
    /// Adds two values and stores the result in the left-hand-side variable.
    static func += (lhs: inout Self, rhs: Self) {
        // swiftlint:disable:next shorthand_operator
        lhs = lhs + rhs
    }
    
    /// Subtracts the second value from the first and stores the difference in the left-hand-side variable.
    static func -= (lhs: inout Self, rhs: Self) {
        // swiftlint:disable:next shorthand_operator
        lhs = lhs - rhs
    }
    
    /// Multiplies two values and stores the result in the left-hand-side variable.
    static func *= (lhs: inout Self, rhs: Self) {
        // swiftlint:disable:next shorthand_operator
        lhs = lhs * rhs
    }
}

// MARK: - CustomStringConvertible
public extension UnsignedAmount {
    var description: String {
        return "\(magnitude) \(Denomination.min.name)"
    }
}

// MARK: - Private Helper
private extension UnsignedAmount {
    
    static func calculate(
        _ lhs: Self,
        _ rhs: Self,
        willOverflowIf overflowCheck: @autoclosure () -> Bool = { false }(),
        operation: (Magnitude, Magnitude) -> Magnitude
    ) -> Self {
        precondition(overflowCheck() == false, "Overflow")
        let magnitudeResult = operation(lhs.magnitude, rhs.magnitude)
        return try! Self.init(magnitude: magnitudeResult)
    }
    
}
