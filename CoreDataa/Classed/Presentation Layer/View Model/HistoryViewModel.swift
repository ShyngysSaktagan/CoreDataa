//
//  HistoryViewModel.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 8/2/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewModel {
    private let coreDataService : CoreDataService
    
    let fetchedResultsController: NSFetchedResultsController<History>
    
    init(context: NSManagedObjectContext, coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        
        let fetchReuqest: NSFetchRequest<History> = History.fetchRequest()
        fetchReuqest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchReuqest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
    }
    
    
    func numberOfSections(fetchedResultsController: NSFetchedResultsController<History>) -> Int {
        coreDataService.numberOfSections(fetchedResultsController: fetchedResultsController)
    }
    
    
    func numberOfRowsInSection(fetchedResultsController:NSFetchedResultsController<History>, section: Int) -> Int {
        coreDataService.numberOfRowsInSection(fetchedResultsController: fetchedResultsController, section: section)
    }
    
    
    func titleForHeaderInSection(fetchedResultsController:NSFetchedResultsController<History>, section: Int) -> String? {
        coreDataService.titleForHeaderInSection(fetchedResultsController: fetchedResultsController, section: section)
    }
    
    
    func tableView(FRC: NSFetchedResultsController<History>, tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        coreDataService.tableView(FRC: FRC, tableView: tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    }
    
    
    func getAllIndexPaths(_ tableView: UITableView) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for j in 0..<tableView.numberOfRows(inSection: 0) {
            indexPaths.append(IndexPath(row: j, section: 0))
        }
        return indexPaths
    }
    
    
    func clearAll(FRC: NSFetchedResultsController<History>, tableView: UITableView) -> UIAlertController {
        let alert = UIAlertController(title: "Уверенсинба? ", message: "", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Уверенмин", style: .default) { (action) in
            print("Uverennost 100%")
            let context = AppDelegate.persistentContainer.viewContext
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: History.fetchRequest())
            deleteRequest.resultType = .resultTypeCount
            do {
                let batchDeleteResult = try context.execute(deleteRequest) as! NSBatchDeleteResult
                print("The batch delete request has deleted \(batchDeleteResult.result!) records.")
                context.reset()
                try? FRC.performFetch()
                tableView.deleteRows(at: self.getAllIndexPaths(tableView), with: .fade)
            } catch {
                let updateError = error as NSError
                print("\(updateError), \(updateError.userInfo)")
            }
        }
        
        let noAction = UIAlertAction(title: "Жо жо", style: .cancel, handler: nil)
    
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        return alert
    }
}
