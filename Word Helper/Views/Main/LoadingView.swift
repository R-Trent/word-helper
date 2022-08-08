//
//  LoadingView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/23/22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 125, height: 125)
                .cornerRadius(25)
                .foregroundStyle(.regularMaterial)
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(.systemGray)))
                Spacer()
                    .frame(height: 10)
                Text("Loading...")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(Color(.systemGray))
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
