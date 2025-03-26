//
//  APIEndpoints.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 26-03-25.
//

enum APIEndpoints {
    static func pokemonList(limit: Int) -> String {
        return "\(Constants.baseURL)/pokemon?limit=\(limit)"
    }
}
