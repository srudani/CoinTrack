//
//  ChartModel.swift
//  CoinTrack
//
//  Created by Sandip Rudani on 2022-10-11.
//

import Foundation

struct ChartModel: Identifiable {
    let id: String = UUID().uuidString
    let xIndex: Double
    let price: Double
    var shouldAnimate: Bool = false
}

extension CoinModel {
    var chartModel: [ChartModel] {
        return sparklineIn7D?.price?.enumerated().compactMap({ (index, element) in
            return ChartModel(xIndex: Double(index), price: element)
        }) ?? []
    }
}
