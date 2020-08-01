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
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    } ()
    
    private let titleLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureBarButtonItem()
    }
    
    
    func configureBarButtonItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addBookMark))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    @objc func addBookMark() {
        print("ehl")

        let alert = UIAlertController(title: "Are you sure? ", message: "", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "YES", style: .default) { (action) in
            let context     = AppDelegate.persistentContainer.viewContext
            let word        = WordDefinition(context: context)
            word.word       = self.titleLabel.text
            word.definition = self.descriptionLabel.text
//            if context.con
//            if self.someEntityExists(self.descriptionLabel.text!) {
            try? context.save()
//            }
        }
        
        let noAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
    
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
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
    
    
//    func someEntityExists(_ definition: String) -> Bool {
//        let fetchRequest = NSFetchRequest<WordDefinition>(entityName: "WordDefinition")
//        fetchRequest.predicate = NSPredicate(format: "someField = %s", definition)
//
//        var entitiesCount = 0
//
//        do {
//            entitiesCount = try AppDelegate.persistentContainer.viewContext.count(for: fetchRequest)
//        }
//        catch {
//            print("error executing fetch request: \(error)")
//        }
//
//        return entitiesCount > 0
//    }
}

