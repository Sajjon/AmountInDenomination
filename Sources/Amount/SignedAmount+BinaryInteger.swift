//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-02.
//

import Foundation

public extension SignedAmount {
    init() {
        implementMe()
    }
    
    init<T>(_ source: T) where T : BinaryInteger {
        implementMe()
    }
    
    // Optional?
    init<T>(_ source: T) where T : BinaryFloatingPoint {
        implementMe()
    }
    
    init<T>(clamping source: T) where T : BinaryInteger {
        implementMe()
    }
    
    init?<T>(exactly source: T) where T : BinaryFloatingPoint {
        implementMe()
    }
    
    init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
        implementMe()
    }
    
    init?<T>(exactly source: T) where T : BinaryInteger {
        implementMe()
    }
    
    var words: Words { magnitude.words }
    
//    var bitWidth: Int { magnitude.bitWidth }
    
//    var trailingZeroBitCount: Int { magnitude.trailingZeroBitCount }
    
    static func / (lhs: Self, rhs: Self) -> Self {
        implementMe()
    }
    
    static func /= (lhs: inout Self, rhs: Self) {
        implementMe()
    }
    
    static func % (lhs: Self, rhs: Self) -> Self {
        implementMe()
    }
    
    static func %= (lhs: inout Self, rhs: Self) {
        implementMe()
    }
    
    static func &= (lhs: inout Self, rhs: Self) {
        implementMe()
    }
    
    static func |= (lhs: inout Self, rhs: Self) {
        implementMe()
    }
    
    static func ^= (lhs: inout Self, rhs: Self) {
        implementMe()
    }
    
    prefix static func ~ (x: Self) -> Self {
        implementMe()
    }
    
    static func >>= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        implementMe()
    }
    
    static func <<= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        implementMe()
    }
    
    init(integerLiteral value: IntegerLiteralType) {
        implementMe()
    }
}
