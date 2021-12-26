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
    
    private let networkService: Networking
    private let dataImporter: DataImporter
    private let realmManager: RealmManager?
    private let sectionBuilder: ViewModelBuilder
    //MARK: Bindings
    var onSearchSucceed: (()-> Void)?
    var onSearchError: (() -> Void)?
    var onSavingSucceed: (([IndexPath]) -> Void)?
    var onSavingError: (() -> Void)?
    var onSectionsReload: ((_ sections: IndexSet) -> Void)?
    //MARK: Life cycle
    init(networkService: Networking = ApiService(),
          dataImporter: DataImporter = DataImporter(),
          realmManager: RealmManager? = RealmManager(),
          sectionBuilder: ViewModelBuilder = ViewModelBuilder()) {
        self.realmManager = realmManager
        self.dataImporter = dataImporter
        self.networkService = networkService
        self.sectionBuilder = sectionBuilder
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
    
    private func sectionViewModel(at section: Int) -> MeaningSectionViewModel? {
        return sections[section]
    }
    
    func makeMeaningDetail(for indexPath: IndexPath) -> MeaningDetailViewModel? {
        guard let meaning = cellViewModel(at: indexPath)?.meaning, let
                word = sectionViewModel(at: indexPath.section)?.word else {
                    return nil
                }
        return MeaningDetailViewModel(word: word, meaning: meaning, indexPath: indexPath)
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
                    self.sectionBuilder.makeSectionsOutOf(words: words) { sections in
                        self.sections = sections
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


