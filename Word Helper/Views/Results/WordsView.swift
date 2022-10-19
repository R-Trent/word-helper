//
//  WordsView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/21/22.
//

import SwiftUI
import UIKit
import SimpleToast

struct WordsView: View {
    @EnvironmentObject var model: HelperModel
    
    var words = [Word(word: "REALM", score: 14329), Word(word: "TRAIL", score: 14329), Word(word: "GREAT", score: 14329)]
    
    @State private var showingDictionaryView = false
    @State private var showCopiedToast = false
    
    private let toastOptions = SimpleToastOptions(
        hideAfter: 2,
        modifierType: .slide
    )
    
    var body: some View {
        if model.hasWords {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(model.wordResultsList.results) { foundWord in
                            VStack() {
                                HStack {
                                    Spacer()
                                    WordGuessView(letters: foundWord.word.uppercased(), interactionDisabled: true)
                                    Spacer()
                                }
                                Text("Score: ")
                                    .font(.system(.footnote, design: .rounded))
                                    .fontWeight(.regular)
                                + Text("\(foundWord.score)")
                                    .font(.system(.footnote, design: .rounded))
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical, 5)
                            .background(Color(uiColor: .systemBackground))
                            .sheet(isPresented: $showingDictionaryView) {
                                DictionaryView(word: model.dictionaryWord)
                            }
                            .contextMenu {
                                Button {
                                    copyToClipboard(word: foundWord.word)
                                } label: {
                                    Label("Copy to Clipboard", systemImage: "doc.on.doc")
                                }
                                
                                // The "define this word" feature crashes if running on M1 Mac (presumably dictionary/view controller issues?) so have to run a check
                                if !ProcessInfo.processInfo.isiOSAppOnMac {
                                    Button {
                                        model.dictionaryWord = foundWord.word
                                        showingDictionaryView.toggle()
                                    } label: {
                                        Label("View Definition", systemImage: "doc.text.magnifyingglass")
                                    }
                                }
                            }
                        }
                        if model.wordResultsList.results.count == model.numberOfResults {
                            Button(action: loadMore) {
                                ZStack {
                                    if model.findingWords {
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                            .tint(.gray)
                                            .zIndex(1)
                                    }
                                    Text("Load More Results")
                                        .font(.system(.body, design: .rounded))
                                        .bold()
                                        .opacity(model.findingWords ? 0 : 1)
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .navigationTitle("Results")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(2)
                }
            }
            .padding(12)
            .onDisappear {
                model.numberOfResults = 10
                model.resultCount = 0
                model.resultsCache.removeAll()
            }
            .simpleToast(isPresented: $showCopiedToast, options: toastOptions) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .symbolRenderingMode(.palette)
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .foregroundStyle(.white, Color(.systemBlue))
                        Text("Copied to clipboard!")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .foregroundColor(Color.primary)
                    .cornerRadius(15)
                }
                .padding(.top, 5)
            } else {
                VStack {
                    Spacer()
                    Image(systemName: "exclamationmark.triangle.fill")
                        .symbolRenderingMode(.palette)
                        .font(.system(size: 48, weight: .medium, design: .rounded))
                        .foregroundStyle(.white, Color(.systemRed))
                    
                    Spacer()
                        .frame(height:10)
                    Text("No words found!")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Spacer()
                        .frame(height:5)
                    Text("Make sure your letters and their colors match your game!")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .navigationTitle("Results")
                .navigationBarTitleDisplayMode(.inline)
                .padding(2)
            }
    }
    
    func copyToClipboard(word: String) {
        UIPasteboard.general.string = word
        withAnimation {
            showCopiedToast.toggle()
            let impactMed = UINotificationFeedbackGenerator()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                impactMed.notificationOccurred(.success)
            }
        }
    }
    
    func loadMore() {
        model.findingWords = true
        withAnimation {
            model.numberOfResults += 10
            model.resultCount = 0
            Task {
                do {
                    try await model.callAPI(letters: model.currentWord, evaluations: model.evaluations)
                } catch {
                    print("Error", error)
                }
            }
        }
    }
}

struct WordsView_Previews: PreviewProvider {
    
    static var previews: some View {
        WordsView()
            .environmentObject(HelperModel())
    }
}
