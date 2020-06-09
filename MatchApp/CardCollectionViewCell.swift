//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Leah Pope on 4/21/20.
//  Copyright © 2020 lsp. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var frontImageView: UIImageView!
    
    @IBOutlet var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card: Card) {
        // keep track of the card this cell represents
        self.card = card
        
        // configure cell for reuse
        if card.isMatched {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        // reset the state of the cell
        if card.isFlipped {
            flipUp(speed: 0.0)
        }
        else {
            flipDown(speed: 0.0, delay: 0.0)
        }
       
        frontImageView.image = UIImage.init(named: card.imageName)
    }
    
    func flipUp(speed: TimeInterval = 0.3) {
        card?.isFlipped = true
        // Flip up animation
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [UIView.AnimationOptions.showHideTransitionViews, UIView.AnimationOptions.transitionFlipFromLeft], completion: nil)
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            // Flip down animation
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [UIView.AnimationOptions.showHideTransitionViews, UIView.AnimationOptions.transitionFlipFromLeft], completion: nil)
        }
        card?.isFlipped = false
    }
    
    func remove() {
        // Make image views invisible
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
    
}
