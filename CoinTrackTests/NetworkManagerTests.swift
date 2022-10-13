//
//  NetworkManagerTests.swift
//  CoinTrackTests
//
//  Created by Sandip Rudani on 2022-10-12.
//

import XCTest
@testable import CoinTrack

final class NetworkManagerTests: XCTestCase {
    
    var urlSession: URLSession!
    let urlProvider = EndPoint.coinList.urlResource
    let sampleJson = """
        {
            "data": "Coins"
        }
    """
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }
    

    override func tearDownWithError() throws {
        urlSession = nil
        try super.tearDownWithError()
    }
    
    func testShouldReturnErrorForUnexpectedStatusCode() async {
        let manager = NetworkManager(urlSession: urlSession)
        let response = HTTPURLResponse(url: urlProvider.url!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        MockURLProtocol.requestHandler = { request in
            return (response!, nil)
        }
        
        do {
            let _: [String: String] = try await manager.load(using: urlProvider)
            XCTFail("This should not be passed")

        } catch (let error) {
            XCTAssertTrue(error is NetworkError)
            XCTAssertEqual(error as? NetworkError, NetworkError.badURLResponse)
        }
        
    }
    
    func testShouldReturnDecodingErrorForUnexpectedResponse() async {
        let manager = NetworkManager(urlSession: urlSession)
        let response = HTTPURLResponse(url: urlProvider.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = sampleJson.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            return (response!, data)
        }
        
        do {
            let _: [String] = try await manager.load(using: urlProvider)
            XCTFail("This should not be passed")

        } catch (let error) {
            XCTAssertTrue(error is NetworkError)
            XCTAssertEqual(error as? NetworkError, NetworkError.decodingError)
        }
        
    }
    

    func testParseValidCoinListResponse() async throws {
        let manager = NetworkManager(urlSession: urlSession)
        let response = HTTPURLResponse(url: urlProvider.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let t = type(of: self)
        let bundle = Bundle(for: t.self)
    
        guard let path = bundle.path(forResource: "CoinListResponse", ofType: "json") else {
            XCTFail("Failed to load json response from local file")
            return
        }
        
        let fileUrl = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
        
        MockURLProtocol.requestHandler = { request in
            return (response!, data)
        }
        
        let responsedata: [CoinModel] = try await manager.load(using: urlProvider)
        
        XCTAssertTrue(!responsedata.isEmpty)
    }
    
    func testParseValidCoinDetailsResponse() async throws {
        let manager = NetworkManager(urlSession: urlSession)
        let response = HTTPURLResponse(url: urlProvider.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let t = type(of: self)
        let bundle = Bundle(for: t.self)
    
        guard let path = bundle.path(forResource: "CoinDetailsResponse", ofType: "json") else {
            XCTFail("Failed to load json response from local file")
            return
        }
        
        let fileUrl = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
        
        MockURLProtocol.requestHandler = { request in
            return (response!, data)
        }
        
        let responsedata: CoinDetailModel = try await manager.load(using: urlProvider)
       
        XCTAssertEqual(responsedata.id, "bitcoin")
        XCTAssertEqual(responsedata.symbol, "btc")
        XCTAssertEqual(responsedata.name, "Bitcoin")
    }
    
   
}


class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data { client?.urlProtocol(self, didLoad: data) }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
    }
}
