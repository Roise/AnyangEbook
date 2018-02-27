//
//  AYCoreDataManager.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 2. 23..
//  Copyright © 2018년 roi. All rights reserved.
//

import Foundation
import CoreData


class AYCoreDataManager {
    
    static let shared = AYCoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DownloadedBook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print(storeDescription)
            
            if let error = error as Error?{
                fatalError("unlesolved Error \(error)")
            }
        })
        return container
    }()
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                let error = error as Error?
                print("CoreData save Context Error\(String(describing: error)) / \(error?.localizedDescription)")
            }
        }
        
    }
    
    
}
