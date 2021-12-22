//
//  MeaningDetailViewController.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 22.12.2021.
//

import UIKit

class MeaningDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController(title: "OMg")
        setupConstraints()
        setupTableView()
        
        
    }
    //MARK: Subviews
    private func setupNavigationController(title: String) {
        navigationItem.title = title
        navigationController?.view.backgroundColor = Colors.cellBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        
    }
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.showsVerticalScrollIndicator = false
        return tv
        
        
    }()
    private func setupTableView() {
        let header = MeaningDetailHeader(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: UIScreen.main.bounds.width,
                                                       height: UIScreen.main.bounds.height * 0.5))
        tableView.tableHeaderView = header
        tableView.remembersLastFocusedIndexPath = true
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = .zero
     
    }
    //MARK: Constraints
    private func setupConstraints() {
        view.addSubviewsForAutolayout([
            tableView
        ])
        //table view
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            
        ])
        
        
    }
    
}



extension MeaningDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
