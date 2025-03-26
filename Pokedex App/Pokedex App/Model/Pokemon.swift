//
//  Pokemon.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 25-03-25.
//

import Foundation

struct Pokemon: Codable, Equatable {
    var name: String
    var url: String
    
    var id: String {
        let components = url.split(separator: "/")
        guard let lastComponent = components.last else { return "" }
        return String(lastComponent)
    }
    
    var imageUrl: String {
        return "\(Constants.baseImageURL)\(id)\(Constants.imageExtension)"
    }
}

struct PokemonResponse: Codable {
    var results: [Pokemon]
}
