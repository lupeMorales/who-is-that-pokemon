//
//  PokemonData.swift
//  who is that pokemon
//
//  Created by Guadalupe Morales carmona on 21/11/22.
//

import Foundation

// MARK: - PokemonData
struct PokemonData: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let name: String
    let url: String
        
        
}
