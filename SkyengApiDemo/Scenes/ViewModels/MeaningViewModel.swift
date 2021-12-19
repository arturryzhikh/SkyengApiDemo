//
//  MeaningViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation
struct MeaningViewModel {
    
    let word: String
    
    var meaning: Meaning2Object
    
    var isSaved: Bool {
        do {
            return try Meaning2Object.exists(primaryKey: meaning.id)
        } catch {
            return false
        }
        
    }
    var previewUrl: String {
        return meaning.previewUrl
    }
    
    var translation: String {
        return meaning.translation?.text ?? ""
    }
    init(word: String, meaning: Meaning2Object) {
        self.word = word
        self.meaning = meaning
    }
}


