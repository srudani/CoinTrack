//
//  CoinListViewModelTests.swift
//  CoinTrackTests
//
//  Created by Sandip Rudani on 2022-10-12.
//

import XCTest
@testable import CoinTrack

final class CoinListViewModelTests: XCTestCase {
    let sampleCoinData = [PreviewHelper.instance.coin]
    
    func testInitialStateShouldBeLoading() throws {
        let sut = CoinListViewModel(with: MockCoinService(data: nil, error: nil))

        XCTAssertEqual(sut.state, .loading)
        XCTAssertTrue(sut.allCoins.isEmpty)
    }
    
    func testViewModelStateShouldBeLoadedOnSuccess() async {
        let sut = CoinListViewModel(with: MockCoinService(data: sampleCoinData, error: nil))
        await sut.loadCoins()
        
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.allCoins.count, sampleCoinData.count)
        XCTAssertEqual(sut.allCoins.first?.name, sampleCoinData.first?.name)
    }
    
    func testViewModelStateShouldBeFailedOnFailure() async {
        let sut = CoinListViewModel(with: MockCoinService(data: nil, error: NetworkError.decodingError))
        
        await sut.loadCoins()
        
        guard case .failed(let error) = sut.state else {
            XCTFail("")
            return
        }
        
        XCTAssertEqual(error as? NetworkError, NetworkError.decodingError)
        XCTAssertTrue(sut.allCoins.isEmpty)
    }
}

class MockCoinService: CoinServicing {
    let data: Decodable?
    let error: Error?
    
    init(data: Decodable?, error: Error?) {
        self.data = data
        self.error = error
    }
    
    func getCoins() async throws -> [CoinTrack.CoinModel] {
        if let data = data as? [CoinTrack.CoinModel]{
            return data
        } else if let error = error {
            throw error
        }
        
        throw NetworkError.unknown
    }
    
    
    func getDetails(for coin: CoinTrack.CoinModel) async throws -> CoinTrack.CoinDetailModel {
        if let data = data as? CoinTrack.CoinDetailModel {
            return data
        } else if let error = error {
            throw error
        }
        
        throw NetworkError.unknown
    }
}
