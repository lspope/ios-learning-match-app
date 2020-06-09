//
//  ViewController.swift
//  MatchApp
//
//  Created by Leah Pope on 4/21/20.
//  Copyright © 2020 lsp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var timerLabel: UILabel!
    
    
    let model = CardModel()
    var cardsArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var timer:Timer?
    var milliseconds:Int = 60 * 1000 // 60 seconds
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardsArray = model.getCards()
        
        // Set the View Controller as the datasource and delegate for Collection View
        collectionView.dataSource = self
        collectionView.delegate  = self
        
        // Set up the timer for the game countdown and put it in RunLoop
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Play shuffle sound
        soundPlayer.playSound(effect: SoundManager.SoundEffect.shuffle)
    }
    
    // MARK: - Timer Methods
    @objc func timerFired() {
        // Decrement counter, update label, stop timer if reaches 0, check if user has cleared all pairs
        milliseconds -= 1
        let seconds:Double = Double(milliseconds)/1000.00
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            checkForGameEnd()
        }
    }
    
    // MARK: - Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Return cell
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // configure the card at the cell that is about to be displayed
        let cardCell = cell as? CardCollectionViewCell
        
        // Get the card from the card array
        let card = cardsArray[indexPath.row]
        
        // Configure cell (recall optional chaining)
        cardCell?.configureCell(card: card)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Block user clicks if time is up
        if milliseconds <= 0 {
            return
        }
        
        // Get reference to cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // check the status of the card in the selected cell and act accordingly
        if cell?.card?.isFlipped == false  && cell?.card?.isMatched == false {
            cell?.flipUp()
            soundPlayer.playSound(effect: SoundManager.SoundEffect.flip)
            
            // check if this was first or second card flipped
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            }
            else {
                // run match logic
                checkForMatch(indexPath)
            }
        }
    }
    
    
    // MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        let card1 = cardsArray[firstFlippedCardIndex!.row]
        let card2 = cardsArray[secondFlippedCardIndex.row]

        // get the two collection view cells representing card 1 and 2
        let card1Cell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let card2Cell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
       
        if card1 == card2 {
            // MATCH! Set status and remove the cards
            // Play match sound
            soundPlayer.playSound(effect: SoundManager.SoundEffect.match)
            card1.isMatched = true
            card2.isMatched = true
            card1Cell?.remove()
            card2Cell?.remove()
            // Was that the last pair?
            checkForGameEnd()
        }
        else {
            // NO MATCH! Flip both back over
            // Play no match sound
            soundPlayer.playSound(effect: SoundManager.SoundEffect.nomatch)
            card1.isFlipped = false
            card2.isFlipped = false
            card1Cell?.flipDown()
            card2Cell?.flipDown()
        }
        
        // The round is over so reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd(){
        // Check if there is any card unmatched
        var hasWon = true
    
        for card in cardsArray {
            if !card.isMatched {
                hasWon = false
                break
            }
        }
        
        if hasWon {
            // Show winner alert
            showAlert(title: "Congratulations!", message: "You won the game!")
            timer?.invalidate()
        }
        else {
            // Check if time left
            if milliseconds <= 0 {
                showAlert(title: "Time's Up!", message: "Better luck next time.")
            }
        }
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated:true, completion:nil)
    }
}
