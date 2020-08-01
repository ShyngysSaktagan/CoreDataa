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
    
    private let tableView = UITableView()
    private let fetchedResultsController: NSFetchedResultsController<WordDefinition>

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    init(context: NSManagedObjectContext) {
        let fetchReuqest: NSFetchRequest<WordDefinition> = WordDefinition.fetchRequest()
        fetchReuqest.sortDescriptors = [
        ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        title = "Избранное"
        view.backgroundColor = .white
        configureTableView()
        try? fetchedResultsController.performFetch()

    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let delete = UIContextualAction(style: .normal, title: "Delete") {  (_, _, completion) in
                let context = AppDelegate.persistentContainer.viewContext
                let item = self.fetchedResultsController.object(at: indexPath)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                context.delete(item)
               
                do {
                    try context.save()
                    completion(true)
                } catch let error {
                    print("Error \(error)")
                }
           }
           
           delete.backgroundColor  = .lightRed
           delete.image            = UIImage(systemName: "trash")
           
           let swipeActions        = UISwipeActionsConfiguration(actions: [delete])
           return swipeActions
       }
}


extension FavoritesVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
    }
}


extension FavoritesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        let item = fetchedResultsController.object(at: indexPath)
        cell.set(title: item.word ?? "", description: item.definition ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
            return sections[section].name
        }
        return nil
    }
}
