//
//  FavoritesCell.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class FavoritesVC: UIViewController {    
    private let tableView           = UITableView()
    private let searchController    = UISearchController(searchResultsController: nil)
    private let viewModel           : FavoritesViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        configurView()
        configureTableView()
        configureNavigationItem()
        try? viewModel.fetchedResultsController.performFetch()
    }
    
    
    @objc func clearAll() {
        let alert = viewModel.clearAll(FRC: viewModel.fetchedResultsController, tableView: tableView)
        present(alert, animated: true, completion: nil)
    }
    
    
    func configureNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear all", style: .plain, target: self, action: #selector(clearAll))
        navigationItem.searchController = self.searchController
    }
    
    
    func configurView() {
        title                   = "Избранное"
        view.backgroundColor    = .white
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in make.edges.equalTo(view.safeAreaLayoutGuide) }
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        viewModel.tableView(FRC: viewModel.fetchedResultsController ,tableView: tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    }   
}


extension FavoritesVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
    }
}


extension FavoritesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections(fetchedResultsController: viewModel.fetchedResultsController)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(fetchedResultsController: viewModel.fetchedResultsController, section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        let item = viewModel.fetchedResultsController.object(at: indexPath)
        cell.set(title: item.word ?? "", description: item.definition ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleForHeaderInSection(fetchedResultsController: viewModel.fetchedResultsController, section: section)
    }
}
