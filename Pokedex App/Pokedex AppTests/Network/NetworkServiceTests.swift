//
//  NetworkServiceTests.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 26-03-25.
//

import XCTest
import Combine
@testable import Pokedex_App

class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    var urlSessionMock: URLSessionMock!
    
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        urlSessionMock = URLSessionMock()
        networkService = NetworkService(session: urlSessionMock)
    }
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        networkService = nil
        urlSessionMock = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() {
        let testData = """
        {
            "results": [{"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"}]
        }
        """.data(using: .utf8)!
        
        let testResponse = URLResponse(url: URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")!,
                                       mimeType: "application/json", expectedContentLength: testData.count, textEncodingName: "utf-8")
        
        urlSessionMock.data = testData
        urlSessionMock.response = testResponse
        
        let expectation = self.expectation(description: "Fetch Data Success")
        
        networkService.fetchData(from: "https://pokeapi.co/api/v2/pokemon?limit=151", decodingType: PokemonResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Expected success but got error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                XCTAssertEqual(response.results.count, 1)
                XCTAssertEqual(response.results[0].name, "bulbasaur")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testFetchDataFailure() {
        let simulatedError = URLError(.notConnectedToInternet)
        
        urlSessionMock.error = simulatedError
        
        let expectation = self.expectation(description: "Fetch Data Failure")
        
        networkService.fetchData(from: "https://pokeapi.co/api/v2/pokemon?limit=151", decodingType: PokemonResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error as? URLError, simulatedError)
                    expectation.fulfill()
                case .finished:
                    XCTFail("Expected error but got success.")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success.")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testFetchDataInvalidURL() {
        let invalidURL = "invalid-url"
        
        let expectation = self.expectation(description: "Fetch Data Invalid URL")
        
        networkService.fetchData(from: invalidURL, decodingType: PokemonResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                case .finished:
                    XCTFail("Expected error but got success.")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success.")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testFetchDataDecodingFailure() {
        let invalidData = """
        {
            "invalid_key": "invalid_value"
        }
        """.data(using: .utf8)!
        
        urlSessionMock.data = invalidData
        urlSessionMock.response = URLResponse(url: URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")!,
                                              mimeType: "application/json", expectedContentLength: invalidData.count, textEncodingName: "utf-8")
        
        let expectation = self.expectation(description: "Fetch Data Decoding Failure")
        
        networkService.fetchData(from: "https://pokeapi.co/api/v2/pokemon?limit=151", decodingType: PokemonResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                case .finished:
                    XCTFail("Expected decoding failure but got success.")
                }
            }, receiveValue: { _ in
                XCTFail("Expected decoding failure but got success.")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
