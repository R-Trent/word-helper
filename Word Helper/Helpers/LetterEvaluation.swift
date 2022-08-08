//
//  LetterEvaluation.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/20/22.
//

enum LetterEvaluation {
    case notIncluded // not included in the solution word
    case included    // included, but wrong position
    case match       // included and correct position
}
