//
//  MockNetworkService.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 26-03-25.
//

import Foundation
import Combine
import XCTest
@testable import Pokedex_App

class MockNetworkService: NetworkServiceProtocol {
    var mockPublisher: AnyPublisher<Data, URLError>?
    
    func fetchData<T>(from urlString: String, decodingType: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        guard let publisher = mockPublisher else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return publisher.decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
