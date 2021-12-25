//
//  ViewController.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 16.12.2021.
//

import UIKit
import RealmSwift
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
        return sc
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.hidesWhenStopped = true
        return ai
    }()
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    private var backgroundView: BackgroundView {
        return tableView.backgroundView as! BackgroundView
    }
    //MARK: Other Properties
    
    private let rowHeight = (UIScreen.main.bounds.size.height * 0.085)
    private let rowWidth = UIScreen.main.bounds.width
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
        view.backgroundColor = .systemGroupedBackground
        setupNavigationController(title: "Search")
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
                           forHeaderFooterViewReuseIdentifier: MeaningHeader.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
        tableView.estimatedRowHeight = rowHeight
        tableView.estimatedSectionHeaderHeight = rowHeight
        tableView.estimatedSectionFooterHeight = .zero
        tableView.sectionFooterHeight = .zero
        tableView.backgroundView = BackgroundView()
    }
    private func setupSearchController(placeholder: String) {
        searchController.searchResultsUpdater = self
        searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = placeholder
       
    }
    private func setupNavigationController(title: String) {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
        navigationController?.hidesBarsOnSwipe = false
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

extension SearchViewController: UISearchResultsUpdating  {
    
    func updateSearchResults(for searchController: UISearchController) {
        var lastSearchedText: String = ""
        guard let text = searchController.searchBar.text, text != lastSearchedText else { return }
        lastSearchedText = text
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
        cell.saveAction = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.present(self.savingAlert, animated: true, completion: nil)
            self.viewModel.saveMeaning(at: indexPath)
        }
        cell.viewModel = cellVM
        return cell
        
        
        
    }
    
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (viewModel.sections[section].headerViewModel == nil) ? .zero : rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let vm = viewModel.sections[section].headerViewModel else {
            return nil
        }
        let header = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: MeaningHeader.reuseId) as! MeaningHeader
        header.viewModel = vm
        header.expandAction = { [weak self] in
            guard let self = self else { return }
            self.viewModel.toggleSection(section)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVM = viewModel.makeMeaningDetail(for: indexPath) else {
            return
        }
        let meaningDetailCoordinator = MeaningDetaiCoordinator(presenter: navigationController, meaningDetailViewModel: detailVM, meaningDetailDelegate: viewModel)
        meaningDetailCoordinator.start()
        searchController.searchBar.resignFirstResponder()
    }
  
    
}
//MARK: VIew Model Binding
extension SearchViewController {
    
    //MARK: View model binding
    private func bind(_ viewModel: SearchViewModel) {
        //Reload sections
        viewModel.onSectionsReload = { [weak self] sections in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.tableView.reloadSections(sections, with: .automatic)
                self.backgroundView.isHidden = true
                
            }
            
        }
        //Search success
        viewModel.onSearchSucceed = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.backgroundView.searchFailed = false
                
            }
        }
        
        //Searching error
        viewModel.onSearchError = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.backgroundView.searchFailed = true
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.backgroundView.isHidden = false
            }
        }
        //saving meaning completed
        viewModel.onSavingSucceed = { [weak self] indexPaths in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: indexPaths, with: .automatic)
                self.savingAlert.dismiss(animated: true)
            }
        }
        //on saving meaning error
        viewModel.onSavingError = { [weak self]  in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.savingAlert.dismiss(animated: true) {
                    let errorAlert = UIAlertController(title: "Oops!",
                                                       message: "Error saving word",
                                                       preferredStyle: .alert)
                    self.present(errorAlert,animated: true)
                    errorAlert.dismiss(animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
}

