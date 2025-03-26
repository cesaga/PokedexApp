//
//  URLSessionMock.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 26-03-25.
//

@testable import Pokedex_App
import Foundation
import Combine

class URLSessionMock: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func dataTaskPublisher(for url: URL) -> AnyPublisher<(Data, URLResponse), Error> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let result = (data: data ?? Data(), response: response ?? URLResponse())
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
