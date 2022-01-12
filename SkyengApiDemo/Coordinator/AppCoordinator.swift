//
//  AppCoordinator.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 24.12.2021.
//

import UIKit
class AppCoordinator: Coordinator {
    
    let window: UIWindow
    let rootViewController: UINavigationController
    
    init(window: UIWindow) { 
        self.window = window
        rootViewController = UINavigationController()
        let searchVC = SearchViewController(viewModel: SearchViewModel())
        rootViewController.pushViewController(searchVC, animated: false)
    }
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
