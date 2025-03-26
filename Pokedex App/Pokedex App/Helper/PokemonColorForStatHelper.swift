//
//  PokemonColorForStatHelper.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 26-03-25.
//

import UIKit

class PokemonColorForStatHelper {
    
    static func colorForStat(named stat: String) -> UIColor {
        switch stat {
        case "hp":
            return .systemGreen
        case "attack":
            return .systemYellow
        case "defense":
            return .systemOrange
        case "special-attack":
            return .systemBlue
        case "special-defense":
            return .systemPurple
        case "speed":
            return .systemPink
        default:
            return .black
        }
    }
}

