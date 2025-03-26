//
//  Pokemon.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 25-03-25.
//

import Foundation

struct Pokemon: Codable {
    var name: String
    var url: String
    
    var id: String {
        let components = url.split(separator: "/")
        guard let lastComponent = components.last else { return "" }
        return String(lastComponent)
    }
    
    var imageUrl: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    }
}

struct PokemonResponse: Codable {
    var results: [Pokemon]
}
