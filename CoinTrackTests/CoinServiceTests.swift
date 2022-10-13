//
//  CoinServiceTests.swift
//  CoinTrackTests
//
//  Created by Sandip Rudani on 2022-10-12.
//

import XCTest
@testable import CoinTrack

final class CoinServiceTests: XCTestCase {
    let mockNetworkManager = MockNetworkManager()
    var sut: CoinService!
   
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CoinService(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testShouldSetCorrectURLForCoinListRequest() async {
        let _ = try? await sut.getCoins()
        XCTAssertEqual(mockNetworkManager.url?.absoluteString, "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&sparkline=true&price_change_percentage=24h")
    }
    
    
    func testShouldSetCorrectURLForCoinDetailsRequest() async {
        let _ = try? await sut.getDetails(for: PreviewHelper.instance.coin)
        XCTAssertEqual(mockNetworkManager.url?.absoluteString, "https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
    }
}

class MockNetworkManager: NetworkManaging {
    var url: URL?
   
    func load<T>(using urlProvider: CoinTrack.URLProvider) async throws -> T where T : Decodable, T : Encodable {
        self.url = urlProvider.url
        throw NetworkError.unknown
    }
}
