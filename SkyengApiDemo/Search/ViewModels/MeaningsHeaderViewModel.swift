//
//  MeaningsHeaderViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation


class MeaningsHeaderViewModel {
    
    var collapsed: Bool = true
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
