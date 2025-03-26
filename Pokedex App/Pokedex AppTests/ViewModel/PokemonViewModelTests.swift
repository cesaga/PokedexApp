//
//  PokemonViewModelTests.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 26-03-25.
//

import XCTest
import Combine
@testable import Pokedex_App

class PokemonViewModelTests: XCTestCase {
    
    var viewModel: PokemonViewModel!
    var apiManagerMock: PokemonAPIManagerMock!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        apiManagerMock = PokemonAPIManagerMock()
        viewModel = PokemonViewModel(pokemonAPIManager: apiManagerMock)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        apiManagerMock = nil
        super.tearDown()
    }

    func testFetchPokemonsSuccess() {
        let pokemons = [Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/1"),
                        Pokemon(name: "Charmander", url: "https://pokeapi.co/api/v2/pokemon/2")]
        apiManagerMock.fetchPokemonListResult = .success(pokemons)

        let expectation = self.expectation(description: "Fetch Pokemons Success")
        
        viewModel.$pokemons
            .sink { pokemons in
                if !pokemons.isEmpty {
                    XCTAssertEqual(pokemons.count, 2)
                    XCTAssertEqual(pokemons.first?.name, "Pikachu")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchPokemons(limit: 2)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchPokemonsFailure() {
        let mockError = NSError(domain: "PokemonAPI", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server Error"])
        apiManagerMock.fetchPokemonListResult = .failure(mockError)

        let expectation = self.expectation(description: "Fetch Pokemons Failure")
        
        viewModel.$error
            .sink { error in
                if let error = error as NSError? {
                    XCTAssertEqual(error.code, 500)
                    XCTAssertEqual(error.domain, "PokemonAPI")
                    XCTAssertEqual(error.localizedDescription, "Server Error")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchPokemons(limit: 2)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSearchPokemons() {
        let pokemons = [Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/1"),
                        Pokemon(name: "Charmander", url: "https://pokeapi.co/api/v2/pokemon/2")]
        viewModel.pokemons = pokemons

        viewModel.searchPokemons(query: "Pikachu")

        XCTAssertEqual(viewModel.filteredPokemons.count, 1)
        XCTAssertEqual(viewModel.filteredPokemons.first?.name, "Pikachu")

        viewModel.searchPokemons(query: "")
        
        XCTAssertEqual(viewModel.filteredPokemons.count, 2)
    }
}
