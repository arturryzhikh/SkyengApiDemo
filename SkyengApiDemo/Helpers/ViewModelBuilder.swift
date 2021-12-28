//
//  SectionBuilder.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//




final class ViewModelBuilder {
    
    private let realmManager: RealmManager?
    public init(realmManager: RealmManager? = RealmManager()) {
        self.realmManager = realmManager
    }
    
    
    public func makeSectionsOutOf(words: [Word],
                                  _ completion: ([MeaningSectionViewModel]) -> Void) {
        let sections = words.map { word in
            makeSection(word: word)
            
        }
        completion(sections)
    }
    //
    private func makeSection(word: Word) -> MeaningSectionViewModel {
        let meaningViewModels = makeMeaningViewModels(word: word)
        let header = meaningViewModels.count > 1 ? makeHeader(word: word) : nil
        return MeaningSectionViewModel(cellViewModels: meaningViewModels,
                                       headerViewModel: header, word: word)
    }
    //
    private func makeMeaningViewModels(word: Word) -> [MeaningViewModel] {
        let wordText = word.meanings.count > 1 ? "" : word.text
        return word.meanings.map { meaning in
            //check if the meaning already exists in db
            if let cachedMeaning = realmManager?
                .object(ofType: Meaning2Object.self, forPrimaryKey: meaning.id) {
                //if exists - create vm from that
                return MeaningViewModel(word: word.text,
                                        meaning: Meaning2(managedObject: cachedMeaning))
            } else {
                //if not - get meanig from fetched data
                return MeaningViewModel(word: wordText,
                                        meaning: meaning)
            }
        }
    }
    
    private func makeHeader(word: Word) -> MeaningsHeaderViewModel {
        let count = "\(word.meanings.count)"
        let translations = joinTranslationsIntoOneString(word: word,length: 26)
        return MeaningsHeaderViewModel(word: word.text,
                                       wordsCount: count,
                                       translations: translations)
    }
    
    private func joinTranslationsIntoOneString(word: Word ,length: Int) -> String {
        var result = (word.meanings.first?.translation.text ?? "") + ", "
        //show only a FEW translations in on string ,separated by a comma
        var start = 1
        for index in start..<word.meanings.count {
            guard result.count < length else { return result }
            let translation = word.meanings[index].translation.text
            //add comma or don't if string larger then length
            let separator = (result.count + translation.count < length) ? ", " : ""
            result.append(translation + separator)
            start += 1
            
        }
        //remove last comma and space
        result.removeLast()
        result.removeLast()
        return result
    }
}
