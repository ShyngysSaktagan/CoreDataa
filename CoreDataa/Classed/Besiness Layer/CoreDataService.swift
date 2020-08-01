//
//  FavoriteSaveService.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 8/2/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataService {
    func numberOfSections<T>(fetchedResultsController:NSFetchedResultsController<T>) -> Int
    func numberOfRowsInSection<T>(fetchedResultsController:NSFetchedResultsController<T>, section: Int) -> Int
    func titleForHeaderInSection<T>(fetchedResultsController:NSFetchedResultsController<T>, section: Int) -> String?
    func tableView<T>(FRC: NSFetchedResultsController<T>, tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
}


class CoreDataServiceImpl: CoreDataService {
    func titleForHeaderInSection<T>(fetchedResultsController: NSFetchedResultsController<T>, section: Int) -> String? {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
            return sections[section].name
        }
        return nil
    }
    
    
    func numberOfRowsInSection<T>(fetchedResultsController: NSFetchedResultsController<T>, section: Int) -> Int {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    
    func numberOfSections<T>(fetchedResultsController: NSFetchedResultsController<T>) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    
    func tableView<T>(FRC: NSFetchedResultsController<T>, tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") {  (_, _, completion) in
            let context = AppDelegate.persistentContainer.viewContext
            if let sections = FRC.sections, sections.count > 0 {
                if sections[0].numberOfObjects > 0 {
                    let record = FRC.object(at: indexPath) as! NSManagedObject
                    context.delete(record)
                    do {
                        try context.save()
                    }
                    catch {
                        print ("There was an error")
                    }

                    try? FRC.performFetch()
                    tableView.deleteRows(at: [indexPath], with: .left)
                }
            }
        }
        
        delete.backgroundColor  = .lightRed
        delete.image            = UIImage(systemName: "trash")
        
        let swipeActions        = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
}
