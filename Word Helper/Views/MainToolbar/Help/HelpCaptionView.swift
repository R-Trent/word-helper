//
//  HelpCaptionView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/20/22.
//

import SwiftUI

struct HelpCaptionView: View {
    var letter: String
    var match: Bool?
    
    var body: some View {
        Group {
            Text("The letter ")
                .font(.system(.footnote, design: .rounded))
                .fontWeight(.regular)
            + Text(letter)
                .font(.system(.footnote, design: .rounded))
                .fontWeight(.bold)
            + Text((match ?? false) ? " is in the word and in the correct spot." : " is in the word but in the wrong spot.")
                .font(.system(.footnote, design: .rounded))
                .fontWeight(.regular)
        }
        .multilineTextAlignment(.center)
    }
}

struct HelpCaptionView_Previews: PreviewProvider {
    static var previews: some View {
        HelpCaptionView(letter: "W")
        HelpCaptionView(letter: "W", match: true)
    }
}
