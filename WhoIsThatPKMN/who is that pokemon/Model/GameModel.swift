//
//  GameModel.swift
//  who is that pokemon
//
//  Created by Guadalupe Morales carmona on 21/11/22.
//

import Foundation

struct GameModel{
    
    var score = 0
    
    mutating func checkAnswer(_ userAnswer: String, _ correctAnswer: String) -> Bool  {
        
        if userAnswer.lowercased() == correctAnswer.lowercased() {
            
            score += 1
            return true
            
        }
        return false
    }
    
    func getScore() -> Int {
        return score
        
    }
    
    mutating func resetScore(score: Int){
        self.score = score
    }
}
