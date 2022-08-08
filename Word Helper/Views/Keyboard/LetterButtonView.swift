//
//  LetterButtonView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/20/22.
//

import SwiftUI

struct LetterButtonView: View {
    @EnvironmentObject var model: HelperModel
    var letter: String

    var body: some View {
        Button {
            if model.showingBadLettersView {
                if model.badLetters.contains(letter) { return }
                model.addToBadLetters(letter)
            } else {
                model.addToWord(letter)
            }
        } label: {
            Text(letter)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .frame(minWidth: 25, idealWidth: 35, maxWidth: 55, minHeight: 50, idealHeight: 50, maxHeight: 50)
                .background(Color(.systemGray))
                .foregroundColor(.white)
        }
        .buttonStyle(.plain)
        .cornerRadius(5)
    }
    
}

struct LetterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LetterButtonView(letter: "L")
    }
}
