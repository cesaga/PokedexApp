//
//  NetworkService.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 26-03-25.
//
import Foundation
import Combine

protocol URLSessionProtocol {
    func dataTaskPublisher(for url: URL) -> AnyPublisher<(Data, URLResponse), Error>
}

extension URLSession: URLSessionProtocol {
    func dataTaskPublisher(for url: URL) -> AnyPublisher<(Data, URLResponse), Error> {
        return dataTaskPublisher(for: url)
            .map { ($0.data, $0.response) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(from urlString: String, decodingType: T.Type) -> AnyPublisher<T, Error>
}

class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSessionProtocol
    
    // Inicializador que recibe cualquier instancia que cumpla con URLSessionProtocol (por ejemplo, URLSession.shared)
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(from urlString: String, decodingType: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.0)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
