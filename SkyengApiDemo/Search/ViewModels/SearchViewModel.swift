//
//  SearchViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation
import SwiftUI

final class SearchViewModel: TableViewModel {
    
    //MARK: Properties
    
    var sections: [MeaningSectionViewModel] = []
    
    var networkService: Networking
    //MARK: Bindings
    var onSearchSucceed: (()-> Void)?
    var onSearchError: (() -> Void)?
    var onSavingSucceed: (([IndexPath]) -> Void)?
    var onSavingError: (() -> Void)?
    var onSectionsReload: ((_ sections: IndexSet) -> Void)?
    //MARK: Life cycle
    init(networkService: Networking = ApiService.shared) {
        self.networkService = networkService
    }
    //MARK:  special methods
    private func clear() {
        sections.removeAll()
    }
    func toggleSection(_ section: Int) {
        sections[section].collapsed.toggle()
        onSectionsReload?([section])
    }
    func numberOfRowsIn(section: Int) -> Int {
        return sections[section].count
        
    }
   
}

extension SearchViewModel: NetworkSearching {
    //MARK: Searching
    func search(_ text: String) {
        guard text.isValid else {
            clear()
            onSearchSucceed?()
            return
        }
        
        let request = SearchRequest(text)
        networkService.request(request) { [weak self ]result in
            guard let self = self else {return}
            switch result {
            case .success(let words):
                guard !words.isEmpty else {
                    self.clear()
                    self.onSearchError?()
                    return
                }
    
                DispatchQueue.main.async {
                    SectionBuilder.makeSectionsOutOf(models: words) {
                        self.sections = $0
                        self.onSearchSucceed?()
                    }
                }
                
                case .failure(let error):
                print(error)
                //last try. search locally
                self.onSearchError?()
                return
            }
        }
        
        
    
    
    }
    
    
}


extension SearchViewModel {
    
    func saveMeaning(at indexPath: IndexPath) {
        guard let realm = RealmManager.shared else {
            onSavingError?()
            return
        }
        //get corresponding word and meaning
        let word = sections[indexPath.section].word
        let meaning = sections[indexPath.section].cellViewModels[indexPath.row].meaning
        //check if word is exits
        var wordToSave: Word
        if let cached = realm.object(ofType: Word.self, forPrimaryKey: word.text) {
            wordToSave = cached
        } else {//create new one with data from word from internet ,but without meanings
            wordToSave = Word()
            wordToSave.id = word.id
            wordToSave.text = word.text
        }
        //fetch additional data
        DataImporter().getDataFor(meaning) { result in
            switch result {
            case .failure(let error):
                print(error)
                self.onSavingError?()
                return
            case.success(let meaning):
                realm.update(wordToSave, with: [meaning] ) { error in
                    guard error == nil else {
                        self.onSavingError?()
                        return
                    }
                    self.onSavingSucceed?([indexPath])
                }
                
            }
        }
    }
    
}
//MARK: Read from db
extension SearchViewModel {

//    func search(enitity: Meaning.Type, by searchText: String, completion: ([Meaning]?) -> Void) {
//        //create predicates to search text in ids and word properties of Meaning
//        let wordPredicate = NSPredicate(format: "word CONTAINS[cd] %@", searchText)
//        let translationPredicate = NSPredicate(format: "translation CONTAINS[cd] %@", searchText)
//        //wrap that into OR predicate
//        let orPredicate = NSCompoundPredicate.init(orPredicateWithSubpredicates: [wordPredicate,translationPredicate])
//        //fetch meanings and construct vms if meanings exists
//        CoreDataManager.shared.searchEntitiesOf(type: Meaning.self, predicate: orPredicate) { meanings in
//            completion(meanings)
//        }
//    }


}

