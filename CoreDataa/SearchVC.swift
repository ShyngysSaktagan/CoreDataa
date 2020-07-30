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
    
    private let searchController    = UISearchController(searchResultsController: nil)
    private let tableView           = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        cell.set(title: "a", description: "asdasdasdasdas")
        return cell
    }
}


extension SearchVC :  UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SearchResultVC()
        viewController.setDescription(text: "asdasdasdasdas")
        viewController.title = "a"
        navigationController?.pushViewController(viewController, animated: true)

    }
    
}



extension SearchVC : UISearchBarDelegate {
    
}
