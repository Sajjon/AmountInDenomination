import XCTest
import BigInt
@testable import Amount

final class Tests: XCTestCase {

    func testPositiveSupplyFromPico() throws {
        XCTAssertEqual(
            try PositiveSupply(magnitude: 15, denomination: .pico),
            try PositiveSupply(magnitude: 15_000)
        )
    }
    
    func testNonNegativeSupplyFromPico() throws {
        XCTAssertEqual(
            try NonNegativeSupply(magnitude: 1, denomination: .pico),
            try NonNegativeSupply.init(magnitude: 1_000)
        )
    }
    
    func testAssertThrowsPositiveSupplyWithAmount0() {
        assertThat(code: try PositiveSupply(magnitude: 0), throws: ValueError.valueTooSmall)
    }

    func testUInt256Max() {
        XCTAssertEqual(
            try UInt256(magnitude: "115792089237316195423570985008687907853269984665640564039457584007913129639935").magnitude,
            UInt256Bound.greatestFiniteMagnitude
        )
    }
    
    func testAssertThrowsUInt256WithMaxAmountPlus1() {
        assertThat(code: try UInt256(magnitude: UInt256Bound.greatestFiniteMagnitude + 1), throws: ValueError.valueTooBig)
    }
    
    func testInt256Max() {
        XCTAssertEqual(
            try Int256(sign: .plus, magnitude: "57896044618658097711785492504343953926634992332820282019728792003956564819967").magnitude,
            Int256Bound.greatestFiniteMagnitude
        )
    }
    
    func testInt256Min() {
        XCTAssertEqual(
            try Int256(sign: .minus, magnitude: "57896044618658097711785492504343953926634992332820282019728792003956564819967").magnitude,
            Int256Bound.leastNormalMagnitude
        )
    }
    
    
    
//    func testCheckIfUnsignedNumeric() {
//        func assertIsUnsigned<A>(type: A.Type) {
//            XCTAssertTrue(type is UnsignedNumeric.Type, "Expected type: \(type) to be UnsignedNumeric")
//        }
//
//        assertIsUnsigned(type: BigUInt.self)
//        assertIsUnsigned(type: UInt64.self)
//        assertIsUnsigned(type: UInt256Bound.self)
//        assertIsUnsigned(type: UInt256.self)
//
//    }
//
//    func testCheckIfSigned() {
//        func assertIsSigned<A>(type: A.Type, expected: Bool = true) where A: AmountType {
//            XCTAssert(A.isSigned == expected)
//        }
//
////        assertIsSigned(type: BigUInt.self)
////        assertIsSigned(type: UInt64.self)
////        assertIsSigned(type: UInt256Bound.self)
////        assertIsSigned(type: UInt256.self)
//
//    }
        
    static var allTests = [
        ("testPositiveSupplyFromPico", testPositiveSupplyFromPico),
        ("testNonNegativeSupplyFromPico", testNonNegativeSupplyFromPico),
        ("testAssertThrowsPositiveSupplyWithAmount0", testAssertThrowsPositiveSupplyWithAmount0),
        ("testUInt256Max", testUInt256Max),
        ("testAssertThrowsUInt256WithMaxAmountPlus1", testAssertThrowsUInt256WithMaxAmountPlus1),
        ("testInt256Max", testInt256Max),
        ("testInt256Min", testInt256Min),
//        ("testCheckIfUnsignedNumeric", testCheckIfUnsignedNumeric),
    ]
}

extension XCTestCase {
    
    func assertThat<T, E>(
        code codeThatThrows: @autoclosure () throws -> T,
        throws expectedError: E,
        message: String = ""
    ) where E: Swift.Error & Equatable {
    
        XCTAssertThrowsError(try codeThatThrows(), message) { anyError in
            guard let castedError = anyError as? E else {
                return XCTFail("Wrong error type, expected: \(expectedError), but got: \(anyError)")
            }
            XCTAssertEqual(castedError, expectedError)
        }
        
    }
}
