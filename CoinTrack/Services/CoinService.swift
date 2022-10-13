//
//  CryptoListService.swift
//  CoinTrack
//
//  Created by Sandip Rudani on 2022-10-08.
//

import Foundation

protocol CoinServicing {
    func getCoins() async throws -> [CoinModel]
    func getDetails(for coin: CoinModel) async throws -> CoinDetailModel
}

class CoinService: CoinServicing {
    let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getCoins() async throws -> [CoinModel] {
        let endpoint = EndPoint.coinList
        let urlProvider = endpoint.urlResource
        return try await networkManager.load(using: urlProvider)
    }
    
    func getDetails(for coin: CoinModel) async throws -> CoinDetailModel {
        let endpoint = EndPoint.coinDetails(coin)
        let urlProvider = endpoint.urlResource
        return try await networkManager.load(using: urlProvider)
    }
}

