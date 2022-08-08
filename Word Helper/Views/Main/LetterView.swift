//
//  LetterView.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/20/22.
//

import SwiftUI

struct LetterView: View {
    
    @EnvironmentObject var model: HelperModel
    
    var letter: String?
    var id: Int?
    var colorBlindEnabled: Bool?
    @State private var evaluationState: LetterEvaluation = .notIncluded
    var evaluation: LetterEvaluation?
    var interactionDisabled: Bool?
    
    private var boxColor: Color {
        guard let isBlind = colorBlindEnabled else { return evaluationState.color }
        if let eval = evaluation {
            if (isBlind) {
                return eval.blindColor
            } else {
                return eval.color
            }
        }
        if (isBlind) {
            return evaluationState.blindColor
        }
        return evaluationState.color
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .style(withStroke: Color.gray, lineWidth: 1, fill: boxColor)
                .aspectRatio(1.0, contentMode: .fit)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            if self.letter == " " || self.letter == "" { return }
                            if let id = id {
                                switch (model.evaluations[id]) {
                                case .included:
                                    evaluationState = .match
                                case .match:
                                    evaluationState = .notIncluded
                                case .notIncluded:
                                    evaluationState = .included
                                }
                                model.evaluations[id] = evaluationState
                            }
                        }
                )

            if let letterVal = letter {
                Text(letterVal)
                    .foregroundColor(.white)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
            }
        }
        .disabled(interactionDisabled ?? false)
        .frame(minHeight: 50, maxHeight: 60)
    }
}

struct LetterView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                LetterView(letter: "B", id: 0, colorBlindEnabled: false, evaluation: .match)
                LetterView(letter: "R", id: 1, colorBlindEnabled: false, evaluation: .included)
                LetterView(letter: "O", id: 2, colorBlindEnabled: false, evaluation: .notIncluded)
            }
            Spacer()
                .frame(height:35)
            HStack {
                LetterView(letter: "B", id: 0, colorBlindEnabled: true, evaluation: .match)
                LetterView(letter: "R", id: 1, colorBlindEnabled: true, evaluation: .included)
                LetterView(letter: "O", id: 2, colorBlindEnabled: true, evaluation: .notIncluded)
            }
        }
        .environmentObject(HelperModel())
    }
}



private extension LetterEvaluation {
    var color: Color {
        switch self {
        case .notIncluded:
            return Color(.systemGray)
        case .included:
            return Color(.systemYellow)
        case .match:
            return Color(.systemGreen)
        }
    }
    var blindColor: Color {
        switch self {
        case .notIncluded:
            return Color(.systemGray)
        case .included:
            return Color(.systemTeal)
        case .match:
            return Color(.systemOrange)
        }
    }
}
