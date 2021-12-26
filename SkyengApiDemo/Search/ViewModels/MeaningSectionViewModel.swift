//
//  MeaningSectionViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//



class MeaningSectionViewModel: SectionWithHeaderViewModel {
    
    private var expandable: Bool {
        return cellViewModels.count > 1
    }
    let word: Word
    
    var count: Int {
        if expandable {
            return collapsed ? 0 : cellViewModels.count
        } else {
            return cellViewModels.count
        }
    }
    var collapsed: Bool = true {
        didSet {
            if expandable {
                headerViewModel?.collapsed = collapsed
            }
        }
    }
    var headerViewModel: MeaningsHeaderViewModel?
    
    let cellViewModels: [MeaningViewModel]
    
    init(cellViewModels: [MeaningViewModel],
         headerViewModel: MeaningsHeaderViewModel?, word: Word) {
        self.cellViewModels = cellViewModels
        self.headerViewModel = headerViewModel
        self.word = word
    }
    
}

