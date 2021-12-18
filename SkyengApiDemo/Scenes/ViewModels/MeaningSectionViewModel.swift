//
//  MeaningSectionViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//


class SectionBuilder {
    static func makeSectionsOutOf(words: [Word], completion: ([MeaningSectionViewModel]) -> Void) {
        let result = words.map { word in
            MeaningSectionViewModel(word: word)
        }
        completion(result)
    }
}

struct MeaningSectionViewModel: SectionWithHeaderViewModel {
    
    let word: Word
    
    var headerViewModel: MeaningsHeaderViewModel? {
        return cellViewModels.count > 1 ? makeHeader() : nil
    }
    
    var cellViewModels: [MeaningViewModel] {
        makeMeaningViewModels()
    }
    
    
    init(word: Word) {
        self.word = word
    }
    
    
}
extension MeaningSectionViewModel {
    private func makeMeaningViewModels() -> [MeaningViewModel] {
        let wordText = word.meanings.count > 1 ? "" : word.text
        return word.meanings.map { meaning in
            //check if the meaning already exists in db
            if let cachedMeaning = RealmManager
                .shared?
                .object(ofType: Meaning2.self, forPrimaryKey: meaning.id) {
                //of exists create vm from that
                return MeaningViewModel(word: wordText, meaning: cachedMeaning)
            } else {
                //if no get meanig from json
                return MeaningViewModel(word: wordText, meaning: meaning)
            }
        }
    }
    
    private func joinTranslationsIntoOneString(length: Int) -> String {
        var result = (cellViewModels.first?.translation ?? "") + ", "
        //show only a FEW translations in on string ,separated by a comma
        var start = 1
        for index in start..<cellViewModels.count {
            guard result.count < length else { return result }
            let translation = cellViewModels[index].translation
                //add comma or don't if sting larger then 30
                let separator = (result.count + translation.count < length) ? ", " : ""
                result.append(translation + separator)
                start += 1
            
        }
        //remove last comm and space
        result.removeLast()
        result.removeLast()
        return result
    }
    private func makeHeader() -> MeaningsHeaderViewModel {
        let count = "\(cellViewModels.count)"
        let translations = joinTranslationsIntoOneString(length: 30)
        return MeaningsHeaderViewModel(word: word.text,
                                       wordsCount: count,
                                       translations: translations)
    }
}

