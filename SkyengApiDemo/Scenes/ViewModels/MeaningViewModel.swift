//
//  MeaningViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation
struct MeaningViewModel {
    let word: String
    let meaning: Meaning2
    var isSaved: Bool {
        return Meaning2.exists(primaryKey: meaning.id) ?? false
    }
    var previewUrl: String {
        return meaning.previewUrl
    }
    
    var translation: String {
        return meaning.translation?.text ?? ""
    }
    init(word: String, meaning: Meaning2) {
        self.word = word
        self.meaning = meaning
    }
}


