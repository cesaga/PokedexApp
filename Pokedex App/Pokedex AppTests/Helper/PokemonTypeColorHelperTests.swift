//
//  PokemonTypeColorHelperTests.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 26-03-25.
//

import XCTest

@testable import Pokedex_App

class PokemonTypeColorHelperTests: XCTestCase {
    
    func testColorForBugType() {
        let color = PokemonTypeColorHelper.color(for: "bug")
        XCTAssertEqual(color, "#8BD674")
    }
    
    func testColorForDarkType() {
        let color = PokemonTypeColorHelper.color(for: "dark")
        XCTAssertEqual(color, "#6F6E78")
    }
    
    func testColorForDragonType() {
        let color = PokemonTypeColorHelper.color(for: "dragon")
        XCTAssertEqual(color, "#7383B9")
    }
    
    func testColorForElectricType() {
        let color = PokemonTypeColorHelper.color(for: "electric")
        XCTAssertEqual(color, "#ffd86f")
    }
    
    func testColorForFairyType() {
        let color = PokemonTypeColorHelper.color(for: "fairy")
        XCTAssertEqual(color, "#EBA8C3")
    }
    
    func testColorForFightingType() {
        let color = PokemonTypeColorHelper.color(for: "fighting")
        XCTAssertEqual(color, "#EB4971")
    }
    
    func testColorForFireType() {
        let color = PokemonTypeColorHelper.color(for: "fire")
        XCTAssertEqual(color, "#fb6c6c")
    }
    
    func testColorForFlyingType() {
        let color = PokemonTypeColorHelper.color(for: "flying")
        XCTAssertEqual(color, "#83A2E3")
    }
    
    func testColorForGhostType() {
        let color = PokemonTypeColorHelper.color(for: "ghost")
        XCTAssertEqual(color, "#8571BE")
    }
    
    func testColorForGrassType() {
        let color = PokemonTypeColorHelper.color(for: "grass")
        XCTAssertEqual(color, "#48d0b0")
    }
    
    func testColorForGroundType() {
        let color = PokemonTypeColorHelper.color(for: "ground")
        XCTAssertEqual(color, "#F78551")
    }
    
    func testColorForIceType() {
        let color = PokemonTypeColorHelper.color(for: "ice")
        XCTAssertEqual(color, "#91D8DF")
    }
    
    func testColorForNormalType() {
        let color = PokemonTypeColorHelper.color(for: "normal")
        XCTAssertEqual(color, "#B5B9C4")
    }
    
    func testColorForPoisonType() {
        let color = PokemonTypeColorHelper.color(for: "poison")
        XCTAssertEqual(color, "#9F6E97")
    }
    
    func testColorForPsychicType() {
        let color = PokemonTypeColorHelper.color(for: "psychic")
        XCTAssertEqual(color, "#FF6568")
    }
    
    func testColorForRockType() {
        let color = PokemonTypeColorHelper.color(for: "rock")
        XCTAssertEqual(color, "#D4C294")
    }
    
    func testColorForSteelType() {
        let color = PokemonTypeColorHelper.color(for: "steel")
        XCTAssertEqual(color, "#4C91B2")
    }
    
    func testColorForWaterType() {
        let color = PokemonTypeColorHelper.color(for: "water")
        XCTAssertEqual(color, "#76bdfe")
    }

    func testColorForUnknownType() {
        let color = PokemonTypeColorHelper.color(for: "unknownType")
        XCTAssertEqual(color, "#F000")
    }
}
