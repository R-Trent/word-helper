//
//  MainToolbarView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/22/22.
//

import SwiftUI

struct MainToolbarView: View {
    @EnvironmentObject var model: HelperModel
    
    var body: some View {
        HStack {
            Button(action: viewHelp) {
                Image(systemName: "questionmark.circle")
            }.sheet(isPresented: $model.showingHelpView) {
                HelpView(colorBlindEnabled: model.colorBlindEnabled)
            }
            .font(.system(size: 24, weight: .medium, design: .rounded))
            .frame(width: 44, height: 44, alignment: .center)
            .background(Color(.systemGray5))
            .clipShape(Circle())
            Spacer()
            Button(action: viewSettings) {
                Image(systemName: "gear")
            }.sheet(isPresented: $model.showingSettingsView) {
                SettingsView()            }
            .font(.system(size: 24, weight: .medium, design: .rounded))
            .frame(width: 44, height: 44, alignment: .center)
            .background(Color(.systemGray5))
            .clipShape(Circle())
        }
    }
    
    func viewHelp() {
        model.showingHelpView.toggle()
    }
    func viewSettings() {
        model.showingSettingsView.toggle()
    }
}

struct MainToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        MainToolbarView()
            .environmentObject(HelperModel())
    }
}
