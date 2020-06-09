//
//  Card.swift
//  MatchApp
//
//  Created by Leah Pope on 4/21/20.
//  Copyright © 2020 lsp. All rights reserved.
//

import Foundation

class Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.imageName == rhs.imageName
    }
    
    var imageName:String = ""
    var isMatched = false
    var isFlipped = false
    
}
