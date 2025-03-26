//
//  PokemonDetailViewModel.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 25-03-25.
//

import Foundation
import Combine

protocol PokemonDetailViewModelProtocol: ObservableObject {
    var pokemonDetail: PokemonDetail? { get }
    var error: Error? { get set }
    func fetchPokemonDetails()
}

class PokemonDetailViewModel: ObservableObject, PokemonDetailViewModelProtocol {
    @Published var pokemonDetail: PokemonDetail?
    @Published var error: Error? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let pokemonAPIManager: PokemonAPIManagerProtocol
    
    private let pokemonURL: String
    
    init(pokemonURL: String, pokemonAPIManager: PokemonAPIManagerProtocol) {
        self.pokemonURL = pokemonURL
        self.pokemonAPIManager = pokemonAPIManager
    }
    
    func fetchPokemonDetails() {
        pokemonAPIManager.fetchPokemonDetails(url: pokemonURL)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                    print("Error obteniendo detalles: \(error)")
                }
            }, receiveValue: { [weak self] details in
                self?.pokemonDetail = details
            })
            .store(in: &cancellables)
    }
}
