//
//  SoundManager.swift
//  MatchApp
//
//  Created by Leah Pope on 4/22/20.
//  Copyright © 2020 lsp. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect:SoundEffect)  {
        var soundFile = ""
        switch effect {
        case .flip:
            soundFile = "cardflip"
        case .match:
            soundFile = "dingcorrect"
        case .nomatch:
            soundFile = "dingwrong"
        case .shuffle:
            soundFile = "shuffle"
        }
        // Get the path to the resource (sound file)
        let bundlePath = Bundle.main.path(forResource: soundFile, ofType: ".wav")
        guard bundlePath != nil else {
            return
        }
        // can safely force unwrap at this point due to guard above
        let url = URL(fileURLWithPath: bundlePath!)
        
        // now try to play the sound at the URL
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
        catch {
            print("Could not create an audio player")
            return
        }
    }
    
}
