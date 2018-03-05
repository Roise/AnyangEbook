//
//  AYCoreDataManager.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 2. 23..
//  Copyright © 2018년 roi. All rights reserved.
//

import Foundation
import CoreData

/* ADT

Create
 func addBook(book: Book) -> Void

Read
 func loadData() -> NSFetchedResultController
 
Update
 

Delete
 func deleteData(categoryID: String) -> Void
 
*/

class AYCoreDataManager: NSObject {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AYDownloadDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print(storeDescription)
            if let error = error as Error?{
                fatalError("unlesolved Error \(error)")
            }
        })
        return container
    }()
    
    static let shared = AYCoreDataManager()
    var context: NSManagedObjectContext?
    
    override init() {
        super.init()
        context = self.persistentContainer.viewContext
    }
    //Create
    func addBook(book: Book) {
        
        let savedBook = Entity(entity: Entity.entity(),
                               insertInto: context)
        savedBook.author = book.authorInfo
        savedBook.categoryCode = book.categoryCode
        savedBook.dateInfo = book.dateInfo
        savedBook.thumbnailURL = book.thumbnailURL
        savedBook.title = book.title
        savedBook.fileData = book.downloadBookData!
        
        saveContext()
    }
    
    //Submit
    func saveContext() {
        if (context?.hasChanges)! {
            do {
                try context?.save()
            } catch {
                let error = error as Error?
                print("CoreData save Context Error\(String(describing: error)) / \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
}
