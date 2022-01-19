//
//  MeaningDetailCoordinator.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 24.12.2021.
//

import UIKit

class MeaningDetaiCoordinator: Coordinator {
    
    private var presenter: UINavigationController?
    private var meaningDetailViewModel: MeaningDetailViewModel
    private weak var meaningDetailDelegate: MeaningDetailDelegate?
    init(presenter: UINavigationController?,
         meaningDetailViewModel: MeaningDetailViewModel,
         meaningDetailDelegate: MeaningDetailDelegate) {
        self.presenter = presenter
        self.meaningDetailViewModel = meaningDetailViewModel
        self.meaningDetailDelegate = meaningDetailDelegate
    }
    
    func start() {
        let meaningDetailVC = MeaningDetailViewController(viewModel: meaningDetailViewModel,coordinator: self)
       
        meaningDetailVC.delegate = meaningDetailDelegate
        presenter?.pushViewController(meaningDetailVC, animated: true)
    }
    
    func popViewController(animated: Bool) {
        presenter?.popViewController(animated: animated)
    }
}
