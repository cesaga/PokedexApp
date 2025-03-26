//
//  PokemonDetailViewModelTests.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 26-03-25.
//
import XCTest
import Combine
@testable import Pokedex_App

class PokemonDetailViewModelTests: XCTestCase {
    
    var viewModel: PokemonDetailViewModel!
    var apiManagerMock: PokemonAPIManagerMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        apiManagerMock = PokemonAPIManagerMock()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        apiManagerMock = nil
        super.tearDown()
    }
    
    func testFetchPokemonDetailsSuccess() {
        let pokemonTypeDetail = PokemonTypeDetail(name: "Electric", url: "")
        let pokemonType = PokemonType(slot: 1, type: pokemonTypeDetail)
        let stats = Stats(base_stat: 120, stat: StatModel(name: "hp"))
        let pokemonDetail = PokemonDetail(name: "Pikachu", id: 1, height: 2, weight: 1, types: [pokemonType], stats: [stats])
        apiManagerMock.fetchPokemonDetailsResult = .success(pokemonDetail)
        
        viewModel = PokemonDetailViewModel(pokemonURL: "pokemon_url", pokemonAPIManager: apiManagerMock)
        
        let expectation = self.expectation(description: "Fetch Pokemon Details Success")
        
        viewModel.$pokemonDetail
            .sink { pokemonDetail in
                if let pokemonDetail = pokemonDetail {
                    XCTAssertEqual(pokemonDetail.name, "Pikachu")
                    XCTAssertEqual(pokemonDetail.types.first?.type.name, "Electric")
                    XCTAssertEqual(pokemonDetail.stats.first?.base_stat, 120)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchPokemonDetails()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchPokemonDetailsFailure() {
        let mockError = NSError(domain: "PokemonAPI", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server Error"])
        apiManagerMock.fetchPokemonDetailsResult = .failure(mockError)
        
        viewModel = PokemonDetailViewModel(pokemonURL: "pokemon_url", pokemonAPIManager: apiManagerMock)
        
        let expectation = self.expectation(description: "Fetch Pokemon Details Failure")
        
        viewModel.$pokemonDetail
            .sink { pokemonDetail in
                XCTAssertNil(pokemonDetail)
            }
            .store(in: &cancellables)
        
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
        
        viewModel.fetchPokemonDetails()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
