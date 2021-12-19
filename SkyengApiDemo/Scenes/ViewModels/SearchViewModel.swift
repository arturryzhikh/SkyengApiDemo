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
    func clear() {
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
        guard !text.isEmpty, text.first != " ", text.last != " " else {
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
//MARK: Saving cell view model

//extension SearchViewModel {
//    
//    func saveCellViewModel(at indexPath: IndexPath) {
//        //retrieve corresponding  word
//        let wordToSave = sections[indexPath.section]
//        //retrieve meaning to save
//        let meaningToSave = wordToSave.meanings[indexPath.row]
//        //check if it exists to prevent file fetching from the network
//        guard
//            let meaningNotExists = Meaning2.exists(primaryKey: meaningToSave.id), meaningNotExists == true else {
//                onSavingError?()
//                return
//            }
//        //get image
//        ImageFetcher.shared.downloadImage(request: ImageRequest(url: meaningToSave.imageUrl)) { image, error in
//            guard let image = image , error == nil else {
//                self.onSavingError?()
//                return
//            }
//            guard let previewImageName = FileStoreManager
//                    .shared
//                    .save(image: image,
//                          name: "\(meaningToSave.id)" + "p",
//                          compressionQuality: 1.0),
//                  let imageName = FileStoreManager
//                    .shared
//                    .save(image: image,
//                          name: "\(meaningToSave.id)" + "i") else {
//                        self.onSavingError?()
//                        return
//                    }
//            //wrire cached images names into meaning
//            meaningToSave.previewImageName = previewImageName
//            meaningToSave.imageName = imageName
//            //FIXME:: download sound and save
//            //update word with new meaning
//            wordToSave.meanings.append(meaningToSave)
//            //save it or update if it exists
//            guard let isSaved = RealmManager.shared?.save(wordToSave) else {
//                return
//            }
//            if isSaved {
//                self.onSavingSucceed?(indexPath)
//            } else {
//                self.onSavingError?()
//            }
//           
//            
//        }
//        
//    }
//    
//}
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

