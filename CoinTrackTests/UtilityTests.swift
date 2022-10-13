//
//  UtilityTests.swift
//  CoinTrackTests
//
//  Created by Sandip Rudani on 2022-10-12.
//

import XCTest
@testable import CoinTrack

final class UtilityTests: XCTestCase {
    func testMonateryDescriptionFromDouble() {
        XCTAssertEqual(Double(12).monetaryDescription, "12.00")
        XCTAssertEqual(Double(1234).monetaryDescription, "1.23K")
        XCTAssertEqual(Double(123456).monetaryDescription, "123.46K")
        XCTAssertEqual(Double(12345678).monetaryDescription, "12.35M")
        XCTAssertEqual(Double(1234567890).monetaryDescription, "1.23Bn")
        XCTAssertEqual(Double(123456789012).monetaryDescription, "123.46Bn")
        XCTAssertEqual(Double(12345678901234).monetaryDescription, "12.35Tr")
    }
    
    func testPercentStringFromDouble() {
        XCTAssertEqual(Double(1.2345).asPercentString, "1.23%")
    }
    
    func testNumberStringFromDouble() {
        XCTAssertEqual(Double(1.2345).asNumberString, "1.23")
    }
    
    func testCurrencyWithNumberOfDecimalsStringFromDouble() {
        XCTAssertEqual(Double(1234.56).asCurrencyWithNumberOfDecimals(2), "$1,234.56")
    }
    
}

