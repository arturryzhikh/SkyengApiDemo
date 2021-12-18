//
//  MeaningsHeaderViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation


struct MeaningsHeaderViewModel {
    
    
    let word: String
    let wordsCount: String
    let translations: String
    init(word: String,
         wordsCount: String,
         translations: String) {
        self.word = word
        self.wordsCount = wordsCount
        self.translations = translations
    }
}
