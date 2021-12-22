//
//  ViewModelConfigurable.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import UIKit


protocol ViewModelConfigurable {
    
    associatedtype ViewModel
    
    var viewModel: ViewModel! { get set }
    
    func fillContent(with: ViewModel)
    
    
    
}

