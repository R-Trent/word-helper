//
//  WordleHelperApp.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/20/22.
//

import SwiftUI

@main
struct WordHelperApp: App {
    @StateObject var model = HelperModel()
    
    var body: some Scene {
        WindowGroup {
            let colorScheme: ColorScheme? = {
                switch model.preferredInterface {
                case .system:
                    return nil
                case .light:
                    return .light
                case .dark:
                    return .dark
                }
            }()
            
            MainView()
                .dynamicTypeSize(.small ... .xxLarge)
                .environmentObject(model)
                .preferredColorScheme(model.preferredInterface != .system ? colorScheme : .none)
        }
    }
}
