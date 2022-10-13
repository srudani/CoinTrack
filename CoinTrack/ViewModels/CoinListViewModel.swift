//
//  HomeViewModel.swift
//  CoinTrack
//
//  Created by Sandip Rudani on 2022-10-08.
//

import Foundation
import Combine

enum LoadingState {
    case loading
    case failed(Error)
    case loaded
}

extension LoadingState: Equatable {
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.failed, .failed), (.loaded, .loaded):
            return true
        default:
            return false
        }
    }
}

class CoinListViewModel: ObservableObject {
    private(set) var allCoins: [CoinModel] = []
    
    @Published var state: LoadingState = .loading
    
    let coinService: CoinServicing
    
    init(with coinService: CoinServicing) {
        self.coinService = coinService
    }
    
    func loadCoins() async  {
        do {
            let coins = try await coinService.getCoins()
            await MainActor.run {
                self.state = .loaded
                self.allCoins = coins
            }
        } catch {
            self.state = .failed(error)
        }
    }
}


