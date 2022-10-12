//
//  HelperModel.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/21/22.
//

import SwiftUI

@MainActor
class HelperModel: ObservableObject {
    @Published var currentWord = ""
    @Published var wordResultsList = WordList()
    @Published var resultsShowing = false
    @AppStorage("colorBlind") var colorBlindEnabled = false
    @AppStorage("preferredInterface") var preferredInterface = InterfaceStyle.system
    @AppStorage("numLetters") var numberOfLetters = 5
    @Published var numberOfResults = 10
    
    @Published var hasWords = false
    @Published var showingErrorAlert = false
    @Published var findingWords = false
    @Published var resultsCache = [String]()
    
    @Published var showingWordsView = false
    @Published var showingHelpView = false
    @Published var showingSettingsView = false
    @Published var showingBadLettersView = false
    
    @Published var badLetters = " ".map { String($0) }
    
    @Published var evaluations = [LetterEvaluation](repeating: .notIncluded, count: 5)
    
    @Published var resultCount = 0
    
    var disableKeyboard: Bool {
        currentWord.count == numberOfLetters && !showingBadLettersView
    }
    
    init() {
        reset()
    }
    
    func reset() {
        withAnimation {
            evaluations = [LetterEvaluation](repeating: .notIncluded, count: numberOfLetters)
            currentWord.removeAll()
        }
    }
    
    func addToWord(_ letter: String) {
        withAnimation {
            currentWord += letter
        }
    }
    
    func removeLastLetter() {
        if currentWord.count < 1 { return }
        withAnimation {
            evaluations[currentWord.count - 1] = .notIncluded
            currentWord.removeLast()
        }
        
    }
    
    func resetBadLetters() {
        withAnimation {
            badLetters.removeAll()
            badLetters.append(" ")
        }
    }
    
    func addToBadLetters(_ letter: String) {
        withAnimation {
            badLetters.removeLast()
            badLetters.append(letter)
            badLetters.append(" ")
        }
    }
    
    func callAPI(letters: String, evaluations: [LetterEvaluation]) async throws {
        var apiString = "https://api.datamuse.com/words?sp="
        let newString = letters.replacingOccurrences(of: " ", with: "?")
        var goodLetters = ""
        for num in 0..<letters.count {
            let letter = newString[num]
            switch evaluations[num] {
            case .notIncluded:
                if !badLetters.contains(letter) {
                    addToBadLetters(letter)
                }
                apiString += "?"
            case .included:
                if goodLetters.contains(letter) {
                    //  the current letter is marked as .included in the word, and it is already in goodLetters X times.
                    //  Fix the formatting of the letters in goodLetters so that it only searches for words that have
                    //  X amount of the current letter
                    //
                    //  e.g. "*E*" -> "*E*E*", "*E*E*" -> "*E*E*E*" {See fixAPIString(letter:goodLetters:) method}
                    let numOccurrences = goodLetters.numberOfOccurrencesOf(string: letter)
                    goodLetters = fixAPIString(letter: letter, goodLetters: &goodLetters)
                    goodLetters += ",*\(String(repeating: "\(letter)*", count: numOccurrences+1))"
                } else if apiString.contains(letter) {
                    let numOccurrences = apiString.numberOfOccurrencesOf(string: letter)
                    goodLetters = fixAPIString(letter: letter, goodLetters: &goodLetters)
                    goodLetters += ",*\(String(repeating: "\(letter)*", count: numOccurrences+1))"
                } else {
                    goodLetters += ",*\(letter)*"
                }
                apiString += "?"
            case .match:
                if goodLetters.contains(letter) {
                    let numOccurrences = goodLetters.numberOfOccurrencesOf(string: letter)
                    goodLetters = fixAPIString(letter: letter, goodLetters: &goodLetters)
                    goodLetters += ",*\(String(repeating: "\(letter)*", count: numOccurrences+1))"
                } else if apiString.contains(letter) {
                    let numOccurrences = apiString.numberOfOccurrencesOf(string: letter)
                    goodLetters = fixAPIString(letter: letter, goodLetters: &goodLetters)
                    goodLetters += ",*\(String(repeating: "\(letter)*", count: numOccurrences+1))"
                }
                apiString += letter
            }
            if badLetters.contains(letter) && (apiString.contains(letter) || goodLetters.contains(letter)) {
                var tempLetters = badLetters.joined(separator: "")
                tempLetters = tempLetters.replacingOccurrences(of: letter, with: "")
                badLetters = tempLetters.map { String($0) }
            }
            
            
        }
        
        if goodLetters != "" {
            apiString += "\(goodLetters)"
        }
        if badLetters.count > 1 {
            badLetters.removeLast()
            apiString += "-\(badLetters.joined(separator: ""))"
            badLetters.append(" ")
            
        }
        
        
        //  Fixes situations where use searches for words but all letters are a match
        //  Check if the word is an actual word by asking if there is a dictionary definition
        //  If it has a definition, it is an actual word. Restrict result of API call to 1 word (that word)
        let eval = evaluations.allSatisfy {
            $0 == .match
        }
        if eval {
            if !UIDevice.current.isSimulator && UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: currentWord) {
                apiString += "&max=1"
            } else if UIDevice.current.isSimulator {
                apiString += "&max=1"
            }
        }
        
        guard let url = URL(string: apiString) else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        let wordList = try JSONDecoder().decode([Word].self, from: data)
        self.showingWordsView = true
        
        wordResultsList.results = wordList.filter { word in
            return validateWord(word)
        }
        //  Check to see if there are results, show "No words found" view if not
        if wordResultsList.results.count > 0 {
            findingWords = false
            hasWords = true
        } else {
            findingWords = false
            hasWords = false
        }
    }
    
    func fixBadLetters(apiString: inout String) {
        badLetters.removeLast()
        apiString += "-\(badLetters.joined(separator: ""))"
        badLetters.append(" ")
    }
    
    func getWordList() -> [Word] {
        return wordResultsList.results
    }
    
    func validateWord(_ word: Word) -> Bool {
        var result = false
        if resultsCache.contains(word.word) {
            //  cache results, improves performance with dictionaryHasDefinition() method
            resultCount += 1
            return true
        }
        if resultCount == numberOfResults {
            //  only want to get 10 additional results at a time, improves performance with dictionaryHasDefinition() method
            return false
        }
        let currentWordArray = currentWord.map { $0 }
        for (index, char) in word.word.enumerated() {
            //  Fixes situations where a letter is .included or .notincluded but results show words that have the letter in the same spot (as if it is a match)
            if word.word.count != numberOfLetters || index >= evaluations.count {
                return false
            }
            let uppercased = String(char.uppercased())
            if uppercased == String(currentWordArray[index]) && (evaluations[index] == .included || evaluations[index] == .notIncluded) {
                return false
            }
        }
        if UIDevice.current.isSimulator || ProcessInfo.processInfo.isiOSAppOnMac {
            result = word.word.count == numberOfLetters && !word.word.contains(" ") && word.word.rangeOfCharacter(from: .punctuationCharacters) == nil && word.word.rangeOfCharacter(from: .illegalCharacters) == nil && word.word.rangeOfCharacter(from: .symbols) == nil  && word.word.rangeOfCharacter(from: .decimalDigits) == nil
        } else {
            //  Dictionary check doesn't work on simulator for some reason, works on physical device
            result = word.word.count == numberOfLetters && !word.word.contains(" ") && word.word.rangeOfCharacter(from: .punctuationCharacters) == nil && word.word.rangeOfCharacter(from: .illegalCharacters) == nil && word.word.rangeOfCharacter(from: .symbols) == nil  && word.word.rangeOfCharacter(from: .decimalDigits) == nil
                && UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word.word)
        }
        if result {
            resultCount += 1
            resultsCache.append(word.word)
        }
        return result
    }
    
    func fixAPIString(letter: String, goodLetters: inout String) -> String {
        //  Replaces occurrances of ",*letter*"
        
        //  Remove the letter
        goodLetters = goodLetters.replacingOccurrences(of: "\(letter)", with: "")
        
        //  Remove the ",**" leftover, comma is optional
        let pattern = #",?(.)\1{1,}"#
        goodLetters = goodLetters.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
        
        //  Return fixed string
        return goodLetters
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        do {
            let wordList = try decoder.decode([Word].self, from: json)
            
            self.showingWordsView = true
            
            wordResultsList.results = wordList.filter { word in
                return validateWord(word)
            }
            //  Check to see if there are results, show "No words found" view if not
            if wordResultsList.results.count > 0 {
                findingWords = false
                hasWords = true
            } else {
                findingWords = false
                hasWords = false
            }
        } catch {
            showingErrorAlert = true
            print(error)
        }
        
        
    }
    
}
