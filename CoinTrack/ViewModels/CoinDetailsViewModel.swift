//
//  CoinDetailsViewModel.swift
//  CoinTrack
//
//  Created by Sandip Rudani on 2022-10-09.
//

import Foundation

import Foundation
import Combine

class CoinDetailsViewModel: ObservableObject {
    
    @Published var additionalData: [CoinStatisticsModel] = []
    @Published var coinDescription: String? = nil
  
    let coin: CoinModel
    let coinService: CoinServicing
            
    init(coin: CoinModel, coinService: CoinServicing = CoinService()) {
        self.coin = coin
        self.coinService = coinService
        self.additionalData = getCoinOverview(from: coin)
    }
    
    func loadDetails() async {
        do {
            let coinDetails = try await coinService.getDetails(for: coin)
            await MainActor.run {
                let additionalData = getAdditionalData(coinDetailModel: coinDetails, coinModel: coin)
                self.additionalData.append(contentsOf: additionalData)
                self.coinDescription = coinDetails.readableDescription
            }
        } catch {
            print("Error in loading coin list")
        }
    }
    
    private func getCoinOverview(from coinModel: CoinModel) -> [CoinStatisticsModel] {
        let price =  coinModel.currentPrice.asCurrencyWithNumberOfDecimals(6)
        let pricePercentChange =  coinModel.priceChangePercentage24H
        let priceStat = CoinStatisticsModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.monetaryDescription ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = CoinStatisticsModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = CoinStatisticsModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.monetaryDescription ?? "")
        let volumeStat = CoinStatisticsModel(title: "Volume", value: volume)
        
        let overviewArray: [CoinStatisticsModel] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        return overviewArray
    }
    
    private func getAdditionalData(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [CoinStatisticsModel] {
        let high = coinModel.high24H?.asCurrencyWithNumberOfDecimals(6) ?? "n/a"
        let highStat = CoinStatisticsModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWithNumberOfDecimals(6) ?? "n/a"
        let lowStat = CoinStatisticsModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWithNumberOfDecimals(6) ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = CoinStatisticsModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.monetaryDescription ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = CoinStatisticsModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = CoinStatisticsModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = CoinStatisticsModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [CoinStatisticsModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        return additionalArray
    }
    
}
