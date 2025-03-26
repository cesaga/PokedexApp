//
//  PokemonAPIManagerMock.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 26-03-25.
//

@testable import Pokedex_App
import Foundation
import Combine

class PokemonAPIManagerMock: PokemonAPIManagerProtocol {
    
    var fetchPokemonListResult: Result<[Pokemon], Error>!
    var fetchPokemonDetailsResult: Result<PokemonDetail, Error>!
    
    func fetchPokemonList(limit: Int) -> AnyPublisher<[Pokemon], Error> {
        return Future { promise in
            promise(self.fetchPokemonListResult)
        }
        .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetails(url: String) -> AnyPublisher<PokemonDetail, Error> {
        return Future { promise in
            promise(self.fetchPokemonDetailsResult)
        }
        .eraseToAnyPublisher()
    }
}
