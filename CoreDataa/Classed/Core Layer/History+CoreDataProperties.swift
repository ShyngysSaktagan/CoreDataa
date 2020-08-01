//
//  History+CoreDataProperties.swift
//  
//
//  Created by Shyngys Saktagan on 8/1/20.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var word: String?

}
