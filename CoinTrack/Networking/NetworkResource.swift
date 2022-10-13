//
//  NetworkResource.swift
//  CoinTrack
//
//  Created by Sandip Rudani on 2022-10-12.
//

import Foundation

enum EndPoint {
    case coinList
    case coinDetails(CoinModel)
}

extension EndPoint {
    var urlResource: CoinURLResource {
        switch self {
        case .coinList:
            let queryItems = [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "order", value: "market_cap_desc"),
                URLQueryItem(name: "sparkline", value: "true"),
                URLQueryItem(name: "price_change_percentage", value: "24h")
            ]
            return CoinURLResource(path: "/api/v3/coins/markets", queryItems: queryItems)
        case .coinDetails(let coin):
            let queryItems = [
                URLQueryItem(name: "localization", value: "false"),
                URLQueryItem(name: "tickers", value: "false"),
                URLQueryItem(name: "market_data", value: "false"),
                URLQueryItem(name: "community_data", value: "false"),
                URLQueryItem(name: "developer_data", value: "false"),
                URLQueryItem(name: "sparkline", value: "false")
                
            ]
            return CoinURLResource(path: "/api/v3/coins/\(coin.id)", queryItems: queryItems)
        }
    }
}

struct CoinURLResource {
    let path: String
    let queryItems: [URLQueryItem]
}

extension CoinURLResource: URLProvider {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}
