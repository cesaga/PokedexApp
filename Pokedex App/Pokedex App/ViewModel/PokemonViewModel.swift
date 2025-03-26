//
//  PokemonViewModel.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 25-03-25.
//

import Foundation
import Combine

protocol PokemonViewModelProtocol: ObservableObject {
    var pokemons: [Pokemon] { get }
    var filteredPokemons: [Pokemon] { get }
    var error: Error? { get set }
    func fetchPokemons(limit: Int)
    func searchPokemons(query: String)
}

class PokemonViewModel: ObservableObject, PokemonViewModelProtocol {
    @Published var pokemons: [Pokemon] = []
    @Published var filteredPokemons: [Pokemon] = []
    @Published var error: Error? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let pokemonAPIManager: PokemonAPIManagerProtocol
    
    init(pokemonAPIManager: PokemonAPIManagerProtocol) {
        self.pokemonAPIManager = pokemonAPIManager
    }
    
    func fetchPokemons(limit: Int) {
        pokemonAPIManager.fetchPokemonList(limit: limit)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                    print("Error al obtener Pokémon: \(error)")
                }
            }, receiveValue: { [weak self] pokemons in
                self?.pokemons = pokemons
                self?.filteredPokemons = pokemons
            })
            .store(in: &cancellables)
    }
    
    func searchPokemons(query: String) {
        if query.isEmpty {
            filteredPokemons = pokemons
        } else {
            self.filteredPokemons = self.pokemons.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
    }
}
