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
//        navigationController?.setNavigationBarHidden(false, animated: true)
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
            let wordService = WordServiceImpl()
            let context     = AppDelegate.persistentContainer.viewContext
            let viewModel   = SearchViewModel(movieService: wordService)
            viewController  = SearchVC(context: context, viewModel: viewModel)
        } else {
            viewController  = FavoritesVC(context: AppDelegate.persistentContainer.viewContext)
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
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.set(nameLabel: "История", recordCount: 1, iconImage: "")
        }else {
            cell.set(nameLabel: "Избранные", recordCount: 1, iconImage: "")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label : UILabel = {
            let label = UILabel()
            label.text = "Мои коллекции"
            label.font = .systemFont(ofSize: 24)
            return label
        } ()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        
        if (section == 1) {
            headerView.backgroundColor = .clear
            headerView.addSubview(label)
            label.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(30)
                make.top.bottom.equalToSuperview().inset(10)
            }
        }
        return headerView
    }
    
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if (section == 1) { return "Мои коллекции" }
//        return nil
//    }
}

extension UIColor {
    static let costomBackgroudColor = UIColor(red: 242 / 255, green: 241 / 255, blue: 246 / 255, alpha: 1)
    static let lightRed             = UIColor(red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
}

