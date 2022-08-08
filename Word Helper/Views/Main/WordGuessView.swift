//
//  GuessView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/21/22.
//

import SwiftUI

struct WordGuessView: View {
    @EnvironmentObject var model: HelperModel
    
    var letters: String?
    var colorBlind: Bool?
    var evaluations: [LetterEvaluation]?
    var interactionDisabled: Bool?
    
    
    var body: some View {
        HStack {
            ForEach(0..<model.numberOfLetters, id: \.self) { num in
                let letter = letters?[num..<num+1] ?? ""
                
                if let evals = evaluations {
                    LetterView(letter: letter, id: num, colorBlindEnabled: colorBlind, evaluation: evals[num], interactionDisabled: interactionDisabled ?? false)
                } else {
                    LetterView(letter: letter, id: num, colorBlindEnabled: colorBlind, interactionDisabled: interactionDisabled ?? false)
                }
                
            }
        }
    }
}

struct GuessView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WordGuessView(letters: "RETRO", colorBlind: false, evaluations:[.match, .match, .notIncluded, .notIncluded, .included], interactionDisabled: false)
                .environmentObject(HelperModel())
            WordGuessView(letters: "EARTH", colorBlind: true, evaluations:[.match, .match, .notIncluded, .notIncluded, .included])
                .environmentObject(HelperModel())
        }
        
    }
}
