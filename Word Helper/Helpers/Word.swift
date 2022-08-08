//
//  Word.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/21/22.
//

struct Word: Codable, Hashable, Identifiable {
    var word: String
    var score: Int
    var id: String {
        word
    }
}
