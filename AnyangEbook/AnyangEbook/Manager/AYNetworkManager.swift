//
//  AYNetworkManager.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 1. 12..
//  Copyright © 2018년 roi. All rights reserved.
//

import Foundation

enum CRUDMethod {
    case get
    case post
    case put
    case update
}

class AYNetworkManager {
    
    static let sharedInstance = AYNetworkManager()
    private var task = URLSessionDownloadTask()
    let session = URLSession.shared
    
    public func requestBookList(url: String, complete:  @escaping (Array<Dictionary<String, Any>>?, Bool, Error?) -> Swift.Void)  {
        
        //Todo CRUDMethod
        
        print(url)
        task = session.downloadTask(with: URL.init(string: url)!, completionHandler: { (location, response, error) in
            
            if location != nil {
                let data: Data! = try? Data.init(contentsOf: location!)
                
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject
                    print("responseObject \(responseObject)")
                    let response = responseObject["searchResult"] as AnyObject
                    let results = response as? Array<Dictionary<String, Any>>
                    
                    complete(results, true, nil)
                    
                } catch {
                    
                }
                
            } else {
                
            }
        })
        
        task.resume()
    }
    
}
