//
//  PokemonAPIManager.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 25-03-25.
//
import Foundation
import Combine

protocol PokemonAPIManagerProtocol {
    func fetchPokemonList(limit: Int) -> AnyPublisher<[Pokemon], Error>
    func fetchPokemonDetails(url: String) -> AnyPublisher<PokemonDetail, Error>
}

class PokemonAPIManager: PokemonAPIManagerProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchPokemonList(limit: Int) -> AnyPublisher<[Pokemon], Error> {
        let urlString = APIEndpoints.pokemonList(limit: limit)
        return networkService.fetchData(from: urlString, decodingType: PokemonResponse.self)
            .map { (response: PokemonResponse) in response.results }
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetails(url: String) -> AnyPublisher<PokemonDetail, Error> {
        return networkService.fetchData(from: url, decodingType: PokemonDetail.self)
    }
}
