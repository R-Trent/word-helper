//
//  Keyboard.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/20/22.
//

import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var model: HelperModel
    var topRowArray = "QWERTYUIOP".map{ String($0) }
    var secondRowArray = "ASDFGHJKL".map{ String($0) }
    var thirdRowArray = "ZXCVBNM".map{ String($0) }
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach(topRowArray, id: \.self) { letter in
                    LetterButtonView(letter: letter)
                        .disabled(model.disableKeyboard)
                        .opacity(model.disableKeyboard ? 0.6 : 1)
                }
            }
            HStack(spacing: 2) {
                Spacer()
                ForEach(secondRowArray, id: \.self) { letter in
                    LetterButtonView(letter: letter)
                }
                .disabled(model.disableKeyboard)
                .opacity(model.disableKeyboard ? 0.6 : 1)
                Spacer()
            }
            HStack(spacing: 2) {
                Button {
                    if !model.showingBadLettersView {
                        model.addToWord(" ")
                    }
                    
                } label: {
                    Text("?")
                }
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .frame(minWidth: 40, idealWidth: 50, maxWidth: 65, minHeight: 50, idealHeight: 50, maxHeight: 50)
                .foregroundColor(.white)
                .background(Color(.systemGray))
                .buttonStyle(.plain)
                .cornerRadius(5)
                .disabled(model.disableKeyboard || model.showingBadLettersView)
                .opacity(model.disableKeyboard || model.showingBadLettersView ? 0.3 : 1)
                
                ForEach(thirdRowArray, id: \.self) { letter in
                    LetterButtonView(letter: letter)
                }
                .disabled(model.disableKeyboard)
                .opacity(model.disableKeyboard ? 0.6 : 1)
                
                Button {
                    withAnimation {
                        if model.showingBadLettersView {
                            if model.badLetters.count == 1 { return }
                            model.badLetters.removeLast(2)
                            model.badLetters.append(" ")
                        } else {
                            model.removeLastLetter()
                        }
                    }
                } label: {
                    Image(systemName: "delete.backward")
                }
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .frame(minWidth: 40, idealWidth: 50, maxWidth: 65, minHeight: 50, idealHeight: 50, maxHeight: 50)
                .foregroundColor(.white)
                .background(Color(.systemGray))
                .buttonStyle(.plain)
                .cornerRadius(5)
                
                .opacity(((model.currentWord.count != 0 && !model.showingBadLettersView) || (model.showingBadLettersView && model.badLetters.count > 1)) ? 1 : 0.3)
            }
        }
        .padding(3)
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
            .scaleEffect(Global.keyboardScale)
            .environmentObject(HelperModel())
    }
}
