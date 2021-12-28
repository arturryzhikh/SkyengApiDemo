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
    
    private let imageFetcher: ImageFetching
    private let fileStoreManager: FileStoreManaging
    
    var meaning: Meaning2
    
    var isSaved: Bool {
        return Meaning2Object.isSaved(forPrimaryKey: meaning.id)
    }
    
    var translation: String {
        return meaning.translation.text
    }
    func previewImage(completion: @escaping (UIImage?) -> Void) {
        switch isSaved {
        case true :
            let image = fileStoreManager.loadImage(named: meaning.previewName)
            completion(image)
        case false:
            imageFetcher.setImage(from: meaning.previewUrl) { image in
                completion(image)
                }
            }
        }
    
    init(word: String, meaning: Meaning2,
         imageFetcher: ImageFetching = ImageFetcher(),
         fileStoreManager: FileStoreManaging = FileStoreManager()) {
        
        self.fileStoreManager = fileStoreManager
        self.imageFetcher = imageFetcher
        self.word = word
        self.meaning = meaning
        
    }
}


