//
//  ViewController.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 16.12.2021.
//

import UIKit

final class SearchViewController: UIViewController {
    
    //MARK: Subviews
    private let savingAlert: UIAlertController = {
        let savingAlert = UIAlertController(title: "Saving word",
                                            message: nil,
                                            preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel",
                                   style: .cancel) { action in
            //FiXME: cancel algorithm
        }
        savingAlert.addAction(action)
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.isUserInteractionEnabled = false
        indicator.color = Colors.link
        indicator.startAnimating()
        savingAlert.view.addSubviewsForAutolayout([indicator])
        NSLayoutConstraint.activate([
            indicator.topAnchor
                .constraint(equalTo: savingAlert.view.topAnchor,constant: 20),
            indicator.trailingAnchor
                .constraint(equalTo: savingAlert.view.trailingAnchor,constant: -16)
        ])
        return savingAlert
    }()
    private let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.definesPresentationContext = true
        return sc
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        return ai
    }()
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    //MARK: Other Properties
    private var rowHeight = (UIScreen.main.bounds.size.height * 0.09)
    private let viewModel: SearchViewModel!
    
    //MARK:  Life cycle
    init(viewModel: SearchViewModel)  {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationController(title: "Skyeng translate")
        setupSearchController(placeholder: "Search new words")
        setupTableView()
        setupConstraints()
        bind(viewModel)
        
        
    }
    //MARK: Initial setup
    private func setupTableView() {
        tableView.register(MeaningCell.self,
                           forCellReuseIdentifier: MeaningCell.reuseId)
        tableView.register(MeaningHeader.self,
                           forCellReuseIdentifier: MeaningHeader.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
        tableView.sectionFooterHeight = .zero
        tableView.backgroundView = BackgroundView()
    }
    private func setupSearchController(placeholder: String) {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = placeholder
        searchController.becomeFirstResponder()
    }
    private func setupNavigationController(title: String) {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = title
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    //MARK: Constraints
    private func setupConstraints() {
        view.addSubviewsForAutolayout([
            tableView,
            activityIndicator
        ])
        //table view
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            
        ])
        //activity indicator
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
    }
    
}
//MARK: UISearchResultsUpdating delegate

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.search(text)
        activityIndicator.startAnimating()
        
    }
    
    
}

//MARK: UITableViewDataSource
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsIn(section: section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MeaningCell.reuseId, for: indexPath) as? MeaningCell,
        let cellVM = viewModel.cellViewModel(at: indexPath) else  {
            fatalError()
        }
        cell.saveAction = {
            
        }
        cell.viewModel = cellVM
        return cell
    
        
        
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (viewModel.headerViewModel(at: section) == nil) ? 0 : rowHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableCell(withIdentifier: MeaningHeader.reuseId) as? MeaningHeader ,
              let viewModel = viewModel.headerViewModel(at: section) else {
                  return nil
              }
        header.viewModel  = viewModel
        header.expandAction = {
            print("HEADER TAPPPPPED")
        }
        return header
    }
    
}
//MARK: VIew Model Binding
extension SearchViewController {
    //MARK: View model binding
    private func bind(_ viewModel: SearchViewModel) {
        //search completed
        viewModel.onSearchSucceed = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                if let bacgroundView = self?
                    .tableView
                    .backgroundView as? BackgroundView {
                    bacgroundView.searchFailed = false
                }
                
            }
            
        }
        
        viewModel.onSearchError = { [weak self] in
            DispatchQueue.main.async {
                if let bacgroundView = self?
                    .tableView
                    .backgroundView as? BackgroundView {
                    bacgroundView.searchFailed = true
                }
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                
            }
        }
        //saving meaning completed
        viewModel.onSavingSucceed = { [weak self] indexPath in
            DispatchQueue.main.async {
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                self?.savingAlert.dismiss(animated: true)
            }
        }
        //on saving meaning error
        viewModel.onSavingError = { [weak self]  in
            DispatchQueue.main.async {
                self?.savingAlert.dismiss(animated: true) {
                    let errorAlert = UIAlertController(title: "Oops!", message: "Error saving word", preferredStyle: .alert)
                    self?.present(errorAlert,animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        errorAlert.dismiss(animated: true, completion: nil)
                        
                    }
                }
                
            }
            
        }
        
    }
    
    
}
