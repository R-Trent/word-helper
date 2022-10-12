//
//  TipView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/20/22.
//

import SwiftUI

struct TipView: View {
    var imageName: String
    var caption: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .renderingMode(.original)
                .font(.system(size: 45, weight: .semibold, design: .rounded))
                .foregroundColor(.blue)
            Spacer()
                .frame(width: 35)
            Text(caption)
                .font(.system(.body, design: .rounded))
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 225, alignment: .leading)
        }
        .frame(height: 75, alignment: .center)
    }
}

struct TipView_Previews: PreviewProvider {
    static var previews: some View {
        TipView(imageName: "1.circle.fill", caption: "Simply enter the letters you have already guessed")
    }
}
