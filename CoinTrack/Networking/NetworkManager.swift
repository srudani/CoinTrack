//
//  NetworkManager.swift
//  CoinTrack
//
//  Created by Sandip Rudani on 2022-10-08.
//

import Foundation

protocol URLProvider {
    var url: URL? { get }
}

protocol NetworkManaging {
    func load<T: Codable>(using urlProvider: URLProvider) async throws -> T
}

enum NetworkError: LocalizedError, Equatable {
    case badURL
    case badURLResponse
    case unknown
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .badURL: return "Invalid URL"
        case .badURLResponse: return "Bad response from URL"
        case .unknown: return "Unknown error occured"
        case .decodingError: return "Failed to decode given object"
        }
    }
}

class NetworkManager: NetworkManaging {
    let urlSession: URLSession
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func load<T>(using urlProvider: URLProvider) async throws -> T where T : Decodable, T : Encodable {
        guard let url = urlProvider.url else { throw NetworkError.badURL }
        
        let (data, response) = try await urlSession.data(from: url, delegate: nil)
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.badURLResponse
        }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return result
    }
}

// Updating default caching Since AsyncImage uses url cache
extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
