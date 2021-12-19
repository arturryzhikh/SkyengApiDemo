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
    var onSavingSucceed: ((IndexPath) -> Void)?
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
        networkService.request(request) { result in
            switch result {
            case .success(let words):
                guard !words.isEmpty else {
                    self.clear()
                    self.onSearchError?()
                    return
                }
                SectionBuilder.makeSectionsOutOf(models: words) { sections in
                    self.sections = sections
                    self.onSearchSucceed?()
                }
                
            case .failure(let error):
                print(error)
                self.onSearchError?()
                return
            }
        }
        
        
    
    
    }
    
    
}


extension SearchViewModel {
    
    func saveCellViewModel(at indexPath: IndexPath) {
        let wordTosave = sections[indexPath.section].word
        //check if it not extists
        guard let exists = WordObject.exists(primaryKey: wordTosave.id),
              !exists else  {
                  onSavingError?()
                  return
                  
              }
        let meaningToSave = wordTosave.meanings[indexPath.row]
        DataImporter().getDataFor(meaningToSave) { result in
            switch result {
            case .failure(let error):
                print(error)
                self.onSavingError?()
                return
            case.success(let meaning):
               print(meaning)
            }
        }
    }
    
}
//MARK: View model constructing logic
//extension SearchViewModel {

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


//}

