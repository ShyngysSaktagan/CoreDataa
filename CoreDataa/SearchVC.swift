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
    
    
    func getAllIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for j in 0..<tableView.numberOfRows(inSection: 0) {
            indexPaths.append(IndexPath(row: j, section: 0))
        }
        return indexPaths
    }
    
    
    @objc func clearAll() {
        let alert = UIAlertController(title: "Уверенсинба? ", message: "", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Уверенмин", style: .default) { (action) in
            print("Uverennost 100%")
            let context = AppDelegate.persistentContainer.viewContext
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: History.fetchRequest())
            deleteRequest.resultType = .resultTypeCount
            do {
                let batchDeleteResult = try context.execute(deleteRequest) as! NSBatchDeleteResult
                print("The batch delete request has deleted \(batchDeleteResult.result!) records.")
                context.reset()
                try? self.fetchedResultsController.performFetch()
                self.tableView.deleteRows(at: self.getAllIndexPaths(), with: .fade)
            } catch {
                let updateError = error as NSError
                print("\(updateError), \(updateError.userInfo)")
            }
        }
        
        let noAction = UIAlertAction(title: "Жо жо", style: .cancel, handler: nil)
    
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
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
        viewModel.didLoadTableItems = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !isSearching {
            return 1
        }else {
            return fetchedResultsController.sections?.count ?? 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
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
        let delete = UIContextualAction(style: .normal, title: "Delete") {  (_, _, completion) in
            let context = AppDelegate.persistentContainer.viewContext
            if let sections = self.fetchedResultsController.sections, sections.count > 0 {
                if sections[0].numberOfObjects > 0 {
                    let record = self.fetchedResultsController.object(at: indexPath) as NSManagedObject
                    context.delete(record)
                    do {
                        try context.save()
                    }
                    catch {
                        print ("There was an error")
                    }

                    try? self.fetchedResultsController.performFetch()
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                }
            }
        }
        
        delete.backgroundColor  = .lightRed
        delete.image            = UIImage(systemName: "trash")
        
        let swipeActions        = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
     
    
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
