//
//  CoinDetailsViewModelTest.swift
//  CoinTrackTests
//
//  Created by Sandip Rudani on 2022-10-12.
//

import XCTest
@testable import CoinTrack


final class CoinDetailsViewModelTest: XCTestCase {
    let samplecoin = PreviewHelper.instance.coin
    let sampleCoinDetails = PreviewHelper.instance.coinDetails

    func testShouldHaveNoDeailsOnLoad() throws {
        let sut = CoinDetailsViewModel(coin: samplecoin)
        
        XCTAssertNil(sut.coinDescription)
    }
    
    func testShouldContainOverviewDataOnLoad() {
        let sut = CoinDetailsViewModel(coin: samplecoin)
        
        
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "Current Price"}))
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "Market Capitalization"}))
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "Rank"}))
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "Volume"}))
        XCTAssertTrue(!sut.additionalData.isEmpty)
    }
    
    func testShouldSetAdditionalDataOnLoadingDetailsSuccessfully() async {
        let mockService = MockCoinService(data: sampleCoinDetails, error: nil)
        let sut = CoinDetailsViewModel(coin: samplecoin, coinService: mockService)
        
        await sut.loadDetails()
        
        XCTAssertEqual(sut.coinDescription, "Dummy Description")
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "Current Price"}))
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "Market Capitalization"}))
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "Rank"}))
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "Volume"}))
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "24h High"}))
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "24h Low"}))
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "24h Market Cap Change"}))
        XCTAssertTrue(sut.additionalData.contains(where: { $0.title == "Block Time"}))
    }
    
    func testShouldNotSetAdditionalDataOnFailure() async {
        let mockService = MockCoinService(data: nil, error: NetworkError.unknown)
        let sut = CoinDetailsViewModel(coin: samplecoin, coinService: mockService)
        
        await sut.loadDetails()
        
        XCTAssertNil(sut.coinDescription)
        XCTAssertEqual(sut.additionalData.count, 4)
    }
}
