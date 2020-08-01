//
//  SearchVC.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class SearchVC: UIViewController {
    
    private let viewModel: SearchViewModel
    private let searchController    = UISearchController(searchResultsController: nil)
    private let tableView           = UITableView()
    private let fetchedResultsController: NSFetchedResultsController<History>
    private var isSearching         = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        try? fetchedResultsController.performFetch()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSearching = false
    }
    
    
    init(context: NSManagedObjectContext, viewModel: SearchViewModel) {
        self.viewModel = viewModel
        let fetchReuqest: NSFetchRequest<History> = History.fetchRequest()
        fetchReuqest.sortDescriptors = [
        ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
//
//    private let historyLabel : UILabel = {
//        let label               = UILabel()
//        label.text              = "     Недавные истории"
//        label.textColor         = .label
//        label.font              = .systemFont(ofSize: 18)
//        return label
//    } ()
//
//
//    private let clearButton : UIButton = {
//        let button = UIButton(type: .custom)
//        button.setTitle("Очистить", for: .normal)
//        button.setTitleColor(.gray, for: .normal)
//        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        return button
//    } ()
//
//
//    private lazy var stackView : UIStackView = {
//        let stackView               = UIStackView(arrangedSubviews: [historyLabel, clearButton])
//        stackView.axis              = .horizontal
//        stackView.alignment         = .fill
//        stackView.distribution      = .fill
//        return stackView
//    } ()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bindViewModel() {
        viewModel.didLoadTableItems = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
            return sections[section].name
        }
        return nil
    }
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return stackView
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
     
    
    
    func setupUI() {
        view.backgroundColor    = .white
        title                   = "История"
        configureSearchController()
        configureTableView()
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.separatorStyle = .none
        tableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
    }
}


extension SearchVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSearching {
            if let sections = fetchedResultsController.sections, sections.count > 0 {
                return sections[section].numberOfObjects
            }
            return 0
        }
        return viewModel.words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        if !isSearching {
            let item = fetchedResultsController.object(at: indexPath)
            cell.set(title: (item.wordDefinition?.word)!, description: "")
            
        } else {
            let word = viewModel.words[indexPath.row]
            cell.set(title: word.word, description: word.definition)
        }
        return cell
    }
}
    

extension SearchVC :  UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isSearching {
            let item = fetchedResultsController.object(at: indexPath)
            searchController.searchBar.text = item.wordDefinition?.word
            viewModel.searchMovie(by: (item.wordDefinition?.word)!)
            isSearching = true

        }else {
            let viewController = SearchResultVC()
            let word = viewModel.words[indexPath.row]
            viewController.setDefinition(to: word.word,text: word.definition)
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        

    }
    
}


extension SearchVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 0 {
            tableView.sectionHeaderHeight = 0
            viewModel.searchMovie(by: searchText)
            isSearching = true
        } else if searchText.count == 0 {
            isSearching = false
            tableView.reloadData()
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            let context = AppDelegate.persistentContainer.viewContext
            
            let history = History(context: context)
            let wordDefinition = NSEntityDescription.insertNewObject(forEntityName: "WordDefinition", into: context) as! WordDefinition
            wordDefinition.word = text
            
            history.wordDefinition = wordDefinition
            
            
            try? context.save()
        }
    }
}
