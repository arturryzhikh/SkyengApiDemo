//
//  SectionBuilder.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//




class SectionBuilder {
    
    func makeSectionsOutOf(models: [Word],
                           completion: ([MeaningSectionViewModel]) -> Void) {
        let result = models.map { word in
            MeaningSectionViewModel(word: word)
        }
        completion(result)
    }
}
