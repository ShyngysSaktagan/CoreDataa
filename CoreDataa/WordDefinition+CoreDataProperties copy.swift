//
//  WordDefinition+CoreDataProperties.swift
//  
//
//  Created by Shyngys Saktagan on 8/1/20.
//
//

import Foundation
import CoreData


extension WordDefinition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordDefinition> {
        return NSFetchRequest<WordDefinition>(entityName: "WordDefinition")
    }

    @NSManaged public var word: String?
    @NSManaged public var definition: String?

}
