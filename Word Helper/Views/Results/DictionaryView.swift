//
//  DictionaryView.swift
//  Word Helper
//
//  Created by Ryan Trent on 10/18/22.
//

import SwiftUI

struct DictionaryView: UIViewControllerRepresentable {
    let word: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<DictionaryView>) -> UIReferenceLibraryViewController {
        return UIReferenceLibraryViewController(term: word)
    }

    func updateUIViewController(_ uiViewController: UIReferenceLibraryViewController, context: UIViewControllerRepresentableContext<DictionaryView>) {
    }
}

