//
//  SearchResultVC.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class SearchResultVC: UIViewController {
    
    private let titleLabel = UILabel()
    private let viewModel: FavoritesViewModel
    private let descriptionLabel : UILabel = {
        let label           = UILabel()
        label.font          = .systemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    } ()
    
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureBarButtonItem()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func configureBarButtonItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addBookMark))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    @objc func addBookMark() {
        let context     = AppDelegate.persistentContainer.viewContext
        let word        = WordDefinition(context: context)
        if !someEntityExists(definition: self.descriptionLabel.text!) {
            let alert       = UIAlertController(title: "Success!", message: "You have successfully favorited this user 🎉", preferredStyle: .alert)
            let hoorayButton    = UIAlertAction(title: "Hooray!", style: .default, handler: nil)
            word.word       = self.titleLabel.text
            word.definition = self.descriptionLabel.text
            
            alert.addAction(hoorayButton)
            present(alert, animated: true, completion: nil)
            try? context.save()
            try? self.viewModel.fetchedResultsController.performFetch()
            
        } else {
            let alert = UIAlertController(title: "You've already favorited this user. You must REALLY like this Word! ⛑", message: "", preferredStyle: .alert)
            let okButton    = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }

    }
    
    
    func someEntityExists(definition: String) -> Bool {
        var isContain = false
        if let results = viewModel.fetchedResultsController.fetchedObjects {
            for result in results {
                let resultWord = result.definition?.lowercased()
                if resultWord == definition.lowercased() {
                    isContain = true
                    break
                }
            }
        }
        return isContain
    }
    
    
    func setupUI() {
        view.addSubview(descriptionLabel)
        view.backgroundColor    = .white
        title                   = titleLabel.text
        descriptionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    
    func setDefinition(to word: String = "", text: String) {
        titleLabel.text         = word
        descriptionLabel.text   = text
    }
}
