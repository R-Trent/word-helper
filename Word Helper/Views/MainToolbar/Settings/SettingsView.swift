//
//  SettingsView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/22/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: HelperModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $model.colorBlindEnabled) {
                        VStack(alignment: .leading, spacing: 2.5) {
                            Text("High Contrast Mode")
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.regular)
                                .multilineTextAlignment(.center)
                            Text("For improved color vision")
                                .font(.system(.footnote, design: .rounded))
                                .fontWeight(.regular)
                                .foregroundColor(.secondary)
                                .frame(alignment: .leading)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    HStack {
                        Text("Interface Style")
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.primary)
                        Spacer()
                        Menu {
                            Picker("picker", selection: $model.preferredInterface) {
                                ForEach(InterfaceStyle.allCases, id: \.self) { style in
                                    HStack {
                                        switch style {
                                        case .light:
                                            Image(systemName: "sun.max")
                                        case .dark:
                                            Image(systemName: "moon")
                                        case .system:
                                            Image(systemName: "gear")
                                        }
                                        Text(style.rawValue)
                                    }
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(InlinePickerStyle())

                        } label: {
                            // make your custom button here
                            Text("\(model.preferredInterface.rawValue)")
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.regular)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Main Settings")
                        .font(.system(.subheadline))
                }
                
                Section {
                    let url = "mailto:rtrent.dev@gmail.com?subject=Word%20Helper%20Support%20Request"
                    Link(destination: URL(string: url)!) {
                        HStack {
                            Image(systemName: "envelope")
                                .font(.system(.body, design: .rounded))
                            Text("Contact the Developer")
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.regular)
                                .multilineTextAlignment(.center)
                        }
                    }
                } header: {
                    Text("Contact")
                        .font(.system(.subheadline))
                }
            }
            .navigationTitle("Settings")
            .dynamicTypeSize(.small ... .large)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(HelperModel())
    }
}
