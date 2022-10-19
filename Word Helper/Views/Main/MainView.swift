//
//  ContentView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/20/22.
//

import SwiftUI


struct MainView: View {
    @EnvironmentObject var model: HelperModel
    
    @State var showBadLettersView = true
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if !model.showingBadLettersView {
                        MainToolbarView()
                        Text("Word Helper")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                    }
                    Spacer()
                        .frame(minHeight: 10, idealHeight: 35, maxHeight: 35)
                    Text((model.showingBadLettersView) ? "Enter your incorrect letters!" : "Enter your letters!")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.light)
                    Spacer()
                        .frame(height: 35)
                    if model.showingBadLettersView {
                        BadLettersView()
                            .opacity(model.showingBadLettersView ? 1 : 0)
                    } else {
                        WordGuessView(letters: model.currentWord, colorBlind: model.colorBlindEnabled, evaluations: model.evaluations)
                            .opacity(model.showingBadLettersView ? 0 : 1)
                    }
                    Spacer()
                        .frame(height: 35)
                    VStack {
                        if !model.showingBadLettersView {
                            HStack {
                                Button(action: reset) {
                                    Text("Reset")
                                        .font(.system(.body, design: .rounded))
                                        .bold()
                                }
                                .disabled(model.currentWord.count == 0)
                                .buttonStyle(.bordered)
                                .tint(.red)
                                Spacer()
                                    .frame(width:20)
                                
                                VStack {
                                    NavigationLink(destination: WordsView(), isActive: $model.showingWordsView) {
                                        EmptyView()
                                    }
                                    Button() {
                                        getWords()
                                    } label: {
                                        ZStack {
                                            if model.findingWords {
                                                ProgressView()
                                                    .progressViewStyle(.circular)
                                                    .tint(.white)
                                                    .zIndex(1)
                                            }
                                            Text("Find Words")
                                                .font(.system(.body, design: .rounded))
                                                .bold()
                                                .opacity(model.findingWords ? 0 : 1)
                                        }
                                        
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(model.currentWord.count != model.numberOfLetters)
                                }
                                
                            }
                            .opacity(model.showingBadLettersView ? 0 : 1)
                            Spacer()
                        }
                        HStack {
                            if model.showingBadLettersView {
                                Spacer()
                                Button(action: model.resetBadLetters) {
                                Text("Reset")
                                    .font(.system(.body, design: .rounded))
                                    .bold()
                                }
                                .disabled(model.badLetters.count == 1)
                                .buttonStyle(.bordered)
                                .tint(.red)
                                Spacer()
                                    .frame(width: 25)
                            }
                            Button(action: enterBadLetters) {
                                Text((model.showingBadLettersView) ? "Done" : "Enter Incorrect Letters")
                                    .font(.system(.body, design: .rounded))
                                    .bold()
                            }
                            .buttonStyle(.bordered)
                            if model.showingBadLettersView {
                                Spacer()
                            }
                        }
                        if !model.showingBadLettersView {
                            Spacer()
                            Spacer()
                        }
                    }
                    .alert("Error finding words", isPresented: $model.showingErrorAlert) {
                        Button("Okay", role: .cancel) {}
                    } message: {
                        Text("There was an error finding words based on your input. Please try again in a few seconds.")
                    }
                    Spacer()
                }
                .padding()
                KeyboardView()
                    .padding(2)
                Spacer()
            }
            
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
            
    }
    
    func getWords() {
        model.findingWords = true
        Task {
            do {
                try await model.callAPI(letters: model.currentWord, evaluations: model.evaluations)
            } catch {
                model.showingErrorAlert.toggle()
                print("Error", error)
            }
        }
    }
    
    func enterBadLetters() {
        withAnimation(Animation.spring().speed(0.75)) {
            model.showingBadLettersView.toggle()
        }
    }
    
    func reset() {
        model.resetBadLetters()
        model.reset()
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewInterfaceOrientation(.portrait)
            .environmentObject(HelperModel())
            
    }
}
