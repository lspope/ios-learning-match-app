//
//  CardModel.swift
//  MatchApp
//
//  Created by Leah Pope on 4/21/20.
//  Copyright © 2020 lsp. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        // Generate an empty array to store numbers we've already generated
        var generatedNumbers = [Int]()
        
        // Generate an empty array
        var generatedCards = [Card]()
        
        // Randomly generate 8 pairs of cards
        while generatedCards.count < 16 {
            let rand = Int.random(in: 1...13)
            
            if !generatedNumbers.contains(rand) {
                let card1 = Card()
                let card2 = Card()
                card1.imageName = "card\(rand)"
                card2.imageName = "card\(rand)"
                
                if !generatedCards.contains(card1) {
                    generatedCards += [card1, card2]
                }
                generatedNumbers.append(rand)
                print(rand)
            }
        }
        
        // Randomize the cards within the array
        generatedCards.shuffle()
        
        // Return the array
        return generatedCards
    }
    
}
