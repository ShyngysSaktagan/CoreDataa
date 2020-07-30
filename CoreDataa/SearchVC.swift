//
//  SearchVC.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit
import SnapKit

class SearchVC: UIViewController {
    
    private let viewModel: SearchViewModel
    private let searchController    = UISearchController(searchResultsController: nil)
    private let tableView           = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
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
        return button
    } ()
    
    
    private lazy var stackView : UIStackView = {
        let stackView               = UIStackView(arrangedSubviews: [historyLabel, clearButton])
        stackView.axis              = .horizontal
        stackView.alignment         = .fill
        stackView.distribution      = .fill
        return stackView
    } ()
    
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bindViewModel() {
        viewModel.didLoadTableItems = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return stackView
    }
     
     
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
     
    
    
    func setupUI() {
        view.backgroundColor = .white
        title = "История"
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
        return viewModel.words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        let word = viewModel.words[indexPath.row]
        cell.set(title: word.word, description: word.definition)
        return cell
    }
}
    

extension SearchVC :  UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SearchResultVC()
        let word = viewModel.words[indexPath.row]
        viewController.setDefinition(text: word.definition)
        viewController.title = word.word
        navigationController?.pushViewController(viewController, animated: true)

    }
    
}


extension SearchVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.sectionHeaderHeight = 0
        viewModel.searchMovie(by: searchText)
        
    }
}
