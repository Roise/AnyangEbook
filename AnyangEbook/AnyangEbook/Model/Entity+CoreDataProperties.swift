//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by N4046 on 2018. 2. 26..
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "DownloadedBook")
    }

    @NSManaged public var author: String?
    @NSManaged public var categoryCode: String?
    @NSManaged public var dateInfo: String?
    @NSManaged public var thumbnailURL: String?
    @NSManaged public var title: String?
    @NSManaged public var fileData: NSData?

}



