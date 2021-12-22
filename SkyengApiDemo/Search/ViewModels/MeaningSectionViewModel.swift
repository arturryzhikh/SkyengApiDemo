//
//  MeaningSectionViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//



struct MeaningSectionViewModel: SectionWithHeaderViewModel {
    
    let word: Word
    
    private var expandable: Bool {
        return word.meanings.count > 1
    }
    var count: Int {
        if expandable {
            return collapsed ? 0 : cellViewModels.count
        } else {
            return cellViewModels.count
        }
    }
    var collapsed: Bool = true

    var headerViewModel: MeaningsHeaderViewModel?  {
        return expandable  ? makeHeader() : nil
        
    }
   
    var cellViewModels: [MeaningViewModel] = []
    init(word: Word) {
        self.word = word
        self.cellViewModels = makeMeaningViewModels()
       
    }
    
    
}
extension MeaningSectionViewModel {
    
    private func makeMeaningViewModels() -> [MeaningViewModel] {
        let wordText = expandable ? "" : word.text
   
        return word.meanings.map { meaning in
            //check if the meaning already exists in db
            if let cachedMeaning = RealmManager
                .shared?
                .object(ofType: Meaning2.self, forPrimaryKey: meaning.id) {
                //if exists - create vm from that
                return MeaningViewModel(word: wordText,
                                        meaning: cachedMeaning)
            } else {
                //if not - get meanig from fetched data
                return MeaningViewModel(word: wordText,
                                        meaning: meaning)
            }
        }
    }
    
    private func joinTranslationsIntoOneString(length: Int) -> String {
        var result = (word.meanings.first?.translation?.text ?? "") + ", "
        //show only a FEW translations in on string ,separated by a comma
        var start = 1
        for index in start..<word.meanings.count {
            guard result.count < length else { return result }
            let translation = word.meanings[index].translation?.text ?? ""
                //add comma or don't if string larger then 30
                let separator = (result.count + translation.count < length) ? ", " : ""
                result.append(translation + separator)
                start += 1
            
        }
        //remove last comma and space
        result.removeLast()
        result.removeLast()
        return result
    }
    private func makeHeader() -> MeaningsHeaderViewModel {
        let count = "\(word.meanings.count)"
        let translations = joinTranslationsIntoOneString(length: 26)
        return MeaningsHeaderViewModel(word: word.text,
                                       wordsCount: count,
                                       translations: translations,
                                       collapsed: collapsed)
    }
}

