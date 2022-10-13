//
//  CoinTrackApp.swift
//  CoinTrack
//
//  Created by Sandip Rudani on 2022-10-08.
//

import SwiftUI

@main
struct CoinTrackApp: App {
    var body: some Scene {
        WindowGroup {
            let coinService = CoinService(networkManager: NetworkManager())
            let coinListViewModel = CoinListViewModel(with: coinService)
            CoinListView(viewModel: coinListViewModel)
        }
    }
}
