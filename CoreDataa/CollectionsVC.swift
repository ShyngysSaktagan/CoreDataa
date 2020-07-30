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
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    
    func setupUI() {
        view.backgroundColor = .costomBackgroudColor
        
        configureTitle()
        configureTableView()
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CollectionCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        
    }
    
    
    func configureTitle() {
        title = "Коллекция"
//        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
}


extension CollectionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController : UIViewController!
        if indexPath.row == 0 {
            let wordService = WordServiceImpl()
            viewController = SearchVC(viewModel: SearchViewModel(movieService: wordService))
        } else {
            viewController = FavoritesVC()
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}


extension CollectionsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CollectionCell
        cell.layer.cornerRadius = 16
        if indexPath.row == 0 {
            cell.set(nameLabel: "История", recordCount: 1, iconImage: "")
        }else {
            cell.set(nameLabel: "Избранные", recordCount: 1, iconImage: "")
        }
        return cell
    }
    
    
}




extension UIColor {
    static let costomBackgroudColor = UIColor(red: 242 / 255, green: 241 / 255, blue: 246 / 255, alpha: 1)
}


