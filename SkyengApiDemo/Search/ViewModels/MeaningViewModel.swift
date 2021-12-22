//
//  MeaningViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation

class MeaningViewModel {
    
    let word: String
    
    var meaning: Meaning2
    
    var isSaved: Bool {
        return meaning.isSaved(forPrimaryKey: meaning.id)
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


