//
//  MeaningViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation
import UIKit

class MeaningViewModel {
    
    let word: String
    
    var meaning: Meaning2
    
    var isSaved: Bool {
        return Meaning2Object.isSaved(forPrimaryKey: meaning.id)
    }
    var previewUrl: String {
        return meaning.previewUrl
    }
   
    var translation: String {
        return meaning.translation.text
        
    }
    func previewImage(completion: @escaping (UIImage?) -> Void) {
        //get images from network or local
        if isSaved {
            let image = FileStoreManager.shared.loadImage(named: previewUrl)
            completion(image)
        } else {
            ImageFetcher.shared.setImage(from: "https:" + previewUrl) { image in
                completion(image)
            }
        }
    }
    init(word: String, meaning: Meaning2) {
        self.word = word
        self.meaning = meaning
        
    }
}


