//
//  SearchViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation
import RealmSwift

final class SearchViewModel: TableViewModel {
    
    //MARK: Properties
    
    var sections: [MeaningSectionViewModel] = []
    
    let networkService: Networking
    let dataImporter: DataImporter
    let realmManager: RealmManager?
    //MARK: Bindings
    var onSearchSucceed: (()-> Void)?
    var onSearchError: (() -> Void)?
    var onSavingSucceed: (([IndexPath]) -> Void)?
    var onSavingError: (() -> Void)?
    var onSectionsReload: ((_ sections: IndexSet) -> Void)?
    //MARK: Life cycle
    init?(networkService: Networking = ApiService(),
         dataImporter: DataImporter = DataImporter(),
         realmManager: RealmManager? = RealmManager()) {
        self.realmManager = realmManager
        self.dataImporter = dataImporter
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

extension SearchViewModel {
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
        //get corresponding word and meaning
        let word = sections[indexPath.section].word
        let meaning = sections[indexPath.section].cellViewModels[indexPath.row].meaning.managedObject()
        //check if word is exits
        guard !Meaning2Object.isSaved(forPrimaryKey: meaning.id) else {
            onSavingError?()
            return
        }
        guard let realmManager = self.realmManager else {
            onSavingError?()
            return
        }
        var wordToSave: WordObject
        if let cached = realmManager.object(ofType: WordObject.self, forPrimaryKey: word.text) {
            wordToSave = cached
        } else {//create new one with data from word from internet ,but without meanings
            wordToSave = WordObject()
            wordToSave.id = word.id
            wordToSave.text = word.text
        }
        //fetch additional data
        
        dataImporter.getDataFor(meaning) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print("\(error)")
                self.onSavingError?()
                return
            case.success(let meaning):
                realmManager.update(wordToSave, with: [meaning] ) { error in
                    guard error == nil else {
                        self.onSavingError?()
                        return
                    }
                    //replace meaning at index path with saved one
                    self.sections[indexPath.section].cellViewModels[indexPath.row].meaning =
                    Meaning2(managedObject: meaning)
                    self.onSavingSucceed?([indexPath])
                }
                
            }
        }
    }
    
}
//MARK: MeaningDetailDelegate
extension SearchViewModel: MeaningDetailDelegate {
    func didManage(meaning: Meaning2, at indexPath: IndexPath) {
        sections[indexPath.section].cellViewModels[indexPath.row].meaning = meaning
        onSavingSucceed?([indexPath])
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

