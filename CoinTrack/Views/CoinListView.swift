//
//  HomeView.swift
//  CoinTrack
//
//  Created by Sandip Rudani on 2022-10-08.
//

import SwiftUI

struct CoinListView: View {
    @ObservedObject var viewModel: CoinListViewModel
    
    init(viewModel: CoinListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .loaded:
                    List {
                        ForEach(viewModel.allCoins) { coin in
                            NavigationLink {
                                CoinDetaislView(viewModel: CoinDetailsViewModel(coin: coin))
                            } label: {
                                CoinCellView(coin: coin)
                                    .listRowInsets(.init(top: 20, leading: 0, bottom: 10, trailing: 10))
                            }
                        }
                    }
                    .listStyle(.grouped)
                case .failed(let error):
                    ErrorView(error: error)
                }
            }
            .navigationTitle("Coins")
            .task {
                await viewModel.loadCoins()
            }
        }
    }
}

struct CoinListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView(viewModel: previewHelper.homeVM)
    }
}

struct ErrorView: View {
    let error: Error
    
    init(error: Error) {
        self.error = error
    }
    
    var body: some View {
        Text("Failed to load data with Error: \(error.localizedDescription)")
    }
}



