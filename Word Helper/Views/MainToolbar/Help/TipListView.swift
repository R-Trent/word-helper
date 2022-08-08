//
//  TipListView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/21/22.
//

import SwiftUI

struct TipListView: View {
    var body: some View {
        VStack(spacing: 20) {
            TipView(imageName: "1.circle.fill", caption: "Simply enter the letters you have already guessed")
            TipView(imageName: "2.circle.fill", caption: "Tap each letter to match the color to your evaluation")
            TipView(imageName: "3.circle.fill", caption: "Tap the \"Find Words\" button to find matching words!")
        }
    }
}

struct TipListView_Previews: PreviewProvider {
    static var previews: some View {
        TipListView()
            
    }
}
