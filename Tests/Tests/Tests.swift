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
    
    func testUInt256BoundMin() {
        XCTAssertEqual(UInt256Bound.leastNormalMagnitude, 0)
    }
    
    func testSuperset() {
        let superset = try! UInt256(magnitude: 1)
        XCTAssertEqual(
            UInt256NonZero(other: superset).magnitude,
            1
        )
    }
    
    func testUInt256NonZeroBoundMin() {
        XCTAssertEqual(UInt256NonZeroBound.greatestFiniteMagnitude, UInt256Bound.greatestFiniteMagnitude)
        XCTAssertEqual(UInt256NonZeroBound.leastNormalMagnitude, 1)
    }
    
    func testAssertThrowsUInt256WithMaxAmountPlus1() {
        assertThat(code: try UInt256(magnitude: UInt256Bound.greatestFiniteMagnitude + 1), throws: ValueError.valueTooBig)
    }
    
    static var allTests = [
        ("testPositiveSupplyFromPico", testPositiveSupplyFromPico),
        ("testNonNegativeSupplyFromPico", testNonNegativeSupplyFromPico),
        ("testAssertThrowsPositiveSupplyWithAmount0", testAssertThrowsPositiveSupplyWithAmount0),
        ("testUInt256Max", testUInt256Max),
        ("testUInt256BoundMin", testUInt256BoundMin),
        ("testUInt256NonZeroBoundMin", testUInt256NonZeroBoundMin),
        ("testAssertThrowsUInt256WithMaxAmountPlus1", testAssertThrowsUInt256WithMaxAmountPlus1),
        ("testSuperset", testSuperset),
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
