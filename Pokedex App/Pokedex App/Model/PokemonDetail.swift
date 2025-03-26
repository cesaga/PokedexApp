//
//  PokemonDetail.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 25-03-25.
//

import Foundation

struct PokemonDetail: Decodable {
    let name: String
    let id: Int
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let stats: [Stats]
}

struct PokemonType: Decodable {
    let slot: Int
    let type: PokemonTypeDetail
}

struct PokemonTypeDetail: Decodable {
    let name: String
    let url: String
}

struct Stats: Decodable {
    let base_stat: Int
    let stat: StatModel
}

struct StatModel: Decodable {
    let name: String
}
