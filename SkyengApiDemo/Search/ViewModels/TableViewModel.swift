//
//  TableViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation


public protocol TableViewModel: AnyObject {
    
    associatedtype Section: SectionViewModel
    
   
    var sections: [Section] { get }

    var numberOfSections: Int { get }
    
    func numberOfRowsIn(section: Int) -> Int
    
    func cellViewModel(at indexPath: IndexPath) -> Section.CellViewModel?
 
}
extension TableViewModel {
    
    var numberOfSections: Int {
        return sections.count
    }
   
    func numberOfRowsIn(section: Int) -> Int {
        return sections[section].cellViewModels.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> Section.CellViewModel?  {
        return sections[indexPath.section].cellViewModels[indexPath.row]
    }
    
 }






