//
//  CollectionsVC.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit
import SnapKit

class CollectionsVC: UIViewController {
    
    private let historyViewModel : HistoryViewModel?
    private let favoritesViewModel : FavoritesViewModel?
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    } ()
    
    
    init(historyViewModel: HistoryViewModel, favoritesViewModel: FavoritesViewModel) {
        self.historyViewModel   = historyViewModel
        self.favoritesViewModel = favoritesViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? historyViewModel!.fetchedResultsController.performFetch()
        try? favoritesViewModel!.fetchedResultsController.performFetch()
        self.tableView.reloadData()
    }
    
    
    func setupUI() {
        view.backgroundColor = .costomBackgroudColor
        configureTitle()
        configureTableView()
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.register(CollectionCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.backgroundColor   = .clear
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    func configureTitle() {
        title = "Коллекция"
        navigationController?.navigationBar.prefersLargeTitles      = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .never
        navigationController?.navigationBar.shadowImage             = nil
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}


extension CollectionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController : UIViewController!
        if indexPath.section == 0 {
            let context             = AppDelegate.persistentContainer.viewContext
            let coreDataService     = CoreDataServiceImpl()
            let wordService         = WordServiceImpl()
            let historyViewModel    = HistoryViewModel(context: context, coreDataService: coreDataService)
            let searchViewModel     = SearchViewModel(movieService: wordService)
            viewController          = SearchVC(searchViewModel: searchViewModel, historyViewModel: historyViewModel)
        } else {
            let context             = AppDelegate.persistentContainer.viewContext
            let coreDataService     = CoreDataServiceImpl()
            let viewModel           = FavoritesViewModel(context: context, coreDataService: coreDataService)
            viewController          = FavoritesVC(viewModel: viewModel)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}


extension CollectionsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CollectionCell
        
        cell.backgroundColor    = .clear
        cell.selectionStyle     = .none
        cell.accessoryType      = .disclosureIndicator
        
        if indexPath.section == 0 {
            cell.set(nameLabel: "История", recordCount: historyViewModel?.getCountOfDatas() ?? 0, iconImage: "octopus")
        }else {
            cell.set(nameLabel: "Избранные", recordCount: favoritesViewModel?.getCountOfDatas() ?? 0, iconImage: "starfish")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label : UILabel = {
            let label   = UILabel()
            label.text  = "Мои коллекции"
            label.font  = .systemFont(ofSize: 24)
            return label
        } ()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        
        if (section == 1) {
            headerView.backgroundColor = .costomBackgroudColor
            headerView.addSubview(label)
            label.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(30)
                make.top.bottom.equalToSuperview().inset(10)
            }
        }
        return headerView
    }
}
