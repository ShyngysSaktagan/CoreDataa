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
    
    private let searchViewModel:      SearchViewModel?
    private let historyViewModel:     HistoryViewModel?
    private let searchController    = UISearchController(searchResultsController: nil)
    private let tableView           = UITableView()
    private var isSearching         = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        try? historyViewModel?.fetchedResultsController.performFetch()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSearching = false
    }
    
    
    init(searchViewModel: SearchViewModel, historyViewModel: HistoryViewModel) {
        self.searchViewModel    = searchViewModel
        self.historyViewModel   = historyViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    private let historyLabel : UILabel = {
        let label               = UILabel()
        label.text              = "     Недавные истории"
        label.textColor         = .label
        label.font              = .systemFont(ofSize: 18)
        return label
    } ()


    private let clearButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Очистить", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        return button
    } ()
    
    
    @objc func clearAll() {
        let alert = historyViewModel?.clearAll(FRC: historyViewModel!.fetchedResultsController, tableView: tableView)
        present(alert!, animated: true, completion: nil)
    }


    private lazy var stackView : UIStackView = {
        let stackView               = UIStackView(arrangedSubviews: [historyLabel, clearButton])
        stackView.axis              = .horizontal
        stackView.alignment         = .fill
        stackView.distribution      = .fill
        return stackView
    } ()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bindViewModel() {
        searchViewModel?.didLoadTableItems = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !isSearching {
            return 1
        }else {
            return historyViewModel?.fetchedResultsController.sections?.count ?? 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = historyViewModel?.fetchedResultsController.sections, sections.count > 0 {
            return sections[section].name
        }
        return nil
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        if !isSearching {
            headerView.backgroundColor = .white
            headerView.addSubview(stackView)
            stackView.snp.makeConstraints { make in make.edges.equalToSuperview() }
            return headerView
        } else {
            return nil
        }
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !isSearching {
            return 50
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        historyViewModel?.tableView(FRC: historyViewModel!.fetchedResultsController, tableView: tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    }
     
    
    func setupUI() {
        view.backgroundColor    = .white
        title                   = "История"
        configureSearchController()
        configureTableView()
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.separatorStyle    = .none
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in make.edges.equalTo(view.safeAreaLayoutGuide) }
    }
    
    
    func configureSearchController() {
        navigationItem.searchController                         = searchController
        searchController.searchBar.placeholder                  = "Search"
        searchController.obscuresBackgroundDuringPresentation   = false
        searchController.searchBar.delegate                     = self
        definesPresentationContext                              = true
        
    }
    
    
    func someEntityExists(word: String) -> Bool {
        var isContain = false
        if let results = historyViewModel?.fetchedResultsController.fetchedObjects {
            for result in results {
                let resultWord = result.word?.lowercased()
                if resultWord == word.lowercased() {
                    isContain = true
                    break
                }
            }
        }
        return isContain
    }
}


extension SearchVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSearching {
            if let sections = historyViewModel?.fetchedResultsController.sections, sections.count > 0 {
                return sections[section].numberOfObjects
            }
            return 0
        }
        return (searchViewModel?.words.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        cell.selectionStyle = .none
        if !isSearching {
            let item = historyViewModel?.fetchedResultsController.object(at: indexPath)
            if let title = item?.word {
                cell.set(title: title, description: "")
            }
            
            
        } else {
            let word = searchViewModel?.words[indexPath.row]
            cell.set(title: word!.word, description: word!.definition)
        }
        return cell
    }
}
    

extension SearchVC :  UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSearching {
            let item = historyViewModel?.fetchedResultsController.object(at: indexPath)
            searchController.searchBar.text = item?.word
            searchViewModel!.searchMovie(by: (item?.word)!)
            isSearching = true

        } else {
            let viewController = SearchResultVC()
            let word = searchViewModel?.words[indexPath.row]
            viewController.setDefinition(to: word!.word,text: word!.definition)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}


extension SearchVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 0 {
            isSearching = true
            tableView.sectionHeaderHeight = 0
            searchViewModel?.searchMovie(by: searchText)
        } else if searchText.count == 0 {
            isSearching = false
            tableView.reloadData()
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count ?? 0 != 0 {
            let context = AppDelegate.persistentContainer.viewContext
            if !someEntityExists(word: searchBar.text!) {
                let history = History(context: context)
                history.word = searchBar.text
                try? context.save()
                try? historyViewModel?.fetchedResultsController.performFetch()
                self.tableView.reloadData()
            }
        }
    }
}
