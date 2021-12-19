//
//  SectionViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

public protocol SectionViewModel {
    associatedtype CellViewModel
    var cellViewModels: [CellViewModel] { get }
    var count: Int { get }
}


public protocol SectionWithHeaderViewModel: SectionViewModel {
    associatedtype HeaderViewModel
    var headerViewModel: HeaderViewModel?  { get }
}


public protocol SectionWithFooterViewModel: SectionViewModel {
    associatedtype FooterViewModel
    var footerViewModel: FooterViewModel? { get  }
    
}
