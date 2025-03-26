//
//  PokemonColorForStatHelperTests.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 26-03-25.
//

import XCTest
import UIKit

@testable import Pokedex_App

class PokemonColorForStatHelperTests: XCTestCase {
    
    func testColorForStatHP() {
        let color = PokemonColorForStatHelper.colorForStat(named: "hp")
        XCTAssertEqual(color, .systemGreen)
    }
    
    func testColorForStatAttack() {
        let color = PokemonColorForStatHelper.colorForStat(named: "attack")
        XCTAssertEqual(color, .systemYellow)
    }
    
    func testColorForStatDefense() {
        let color = PokemonColorForStatHelper.colorForStat(named: "defense")
        XCTAssertEqual(color, .systemOrange)
    }
    
    func testColorForStatSpecialAttack() {
        let color = PokemonColorForStatHelper.colorForStat(named: "special-attack")
        XCTAssertEqual(color, .systemBlue)
    }
    
    func testColorForStatSpecialDefense() {
        let color = PokemonColorForStatHelper.colorForStat(named: "special-defense")
        XCTAssertEqual(color, .systemPurple)
    }
    
    func testColorForStatSpeed() {
        let color = PokemonColorForStatHelper.colorForStat(named: "speed")
        XCTAssertEqual(color, .systemPink)
    }
    
    // Test para el caso default
    func testColorForStatDefault() {
        let color = PokemonColorForStatHelper.colorForStat(named: "unknownStat")
        XCTAssertEqual(color, .black)
    }
}
