//
//  BadLettersView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/23/22.
//

import SwiftUI

struct BadLettersView: View {
    @EnvironmentObject var model: HelperModel
    
    let columns = [
        GridItem(.adaptive(minimum: 60, maximum: 60))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                ForEach(model.badLetters, id: \.self) { item in
                    ZStack(alignment: .topTrailing) {
                        LetterView(letter: item, interactionDisabled:true)
                        //  add remove button on all letters excluding the empty square
                        if item != " " {
                            Button {
                                withAnimation {
                                    model.badLetters.removeAll(where: { letter in
                                        letter == item
                                    })
                                }
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.white, Color(.systemRed))
                            }
                            .foregroundColor(.red)
                            .padding(2)
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                        }
                    }
                    
                }
        }
    }
}

struct BadLettersView_Previews: PreviewProvider {
    static var previews: some View {
        BadLettersView()
            .environmentObject(HelperModel())
    }
}
