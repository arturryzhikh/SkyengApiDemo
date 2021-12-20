//
//  SectionBuilder.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//


protocol SectionBuilding {
    
    associatedtype Model
    associatedtype Section: SectionViewModel
    static func makeSectionsOutOf(models: [Model],
                                  completion: ([Section]) -> Void)
}

class SectionBuilder: SectionBuilding {
    
    static func makeSectionsOutOf(models: [Word],
                                  completion: ([MeaningSectionViewModel]) -> Void) {
        let result = models.map { word in
            MeaningSectionViewModel(word: word)
        }
        completion(result)
    }
}
