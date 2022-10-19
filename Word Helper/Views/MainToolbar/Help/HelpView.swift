//
//  HelpView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/20/22.
//

import SwiftUI

struct HelpView: View {
    var colorBlindEnabled: Bool
    
    var body: some View {
        
        VStack {
            Group {
                Text("How to Use")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                    .frame(height:25)
                Text("Word Helper aims to help you solve the daily Wordle challenge.")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
            Spacer()
                .frame(height: 40)
            TipListView()
            Spacer()
                .frame(height:40)
            Text("Examples")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            VStack {
                WordGuessView(letters: "SMART", colorBlind: colorBlindEnabled, evaluations:[.match, .notIncluded, .notIncluded, .notIncluded, .notIncluded], interactionDisabled: true)
                HelpCaptionView(letter: "S", match: true)
                WordGuessView(letters: "BACON", colorBlind: colorBlindEnabled, evaluations:[.notIncluded, .included, .notIncluded, .notIncluded, .notIncluded], interactionDisabled: true)
                HelpCaptionView(letter: "A")
            }
            
        }
        .padding(24)
        .dynamicTypeSize(.small ... .large)
    }

}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(colorBlindEnabled: true)
            .environmentObject(HelperModel())
        HelpView(colorBlindEnabled: false)
            .environmentObject(HelperModel())
    }
}
