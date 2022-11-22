//
//  ImageData.swift
//  who is that pokemon
//
//  Created by Guadalupe Morales carmona on 21/11/22.
//

//llo que esperamos recibir de la API
import Foundation


struct ImageData: Codable {
   
    let sprites: Sprites
    
}

// MARK: - Sprites
class Sprites: Codable {
 
    let other: Other?
   

    init( other: Other?) {
     
        self.other = other
        
    }
}


// MARK: - Other
struct Other: Codable {
  
    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}




