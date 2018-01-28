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

//TODO max page


class AYNetworkManager {
    
    static let sharedInstance = AYNetworkManager()
    private var sessionTask = URLSessionDataTask()
    private var downloadTask = URLSessionDownloadTask()
    private let session = URLSession.shared
    
    public var isLoading = false
    
    public func downloadPDF(url: String, fileName: String, completionHandler: @escaping(Data, Bool, Error?) -> Swift.Void) {
        
        downloadTask = session.downloadTask(with: URL.init(string: url)!, completionHandler: { (url, response, error) in
            let path = Bundle.main.bundlePath
            
            do {
                let data = try Data.init(contentsOf: url!)
                FileManager.default.createFile(atPath: path + fileName, contents: data, attributes: nil)
                completionHandler(data, true, error)
            
            } catch {
                
            }
            
            
        })
        
        downloadTask.resume()
    }
    
    public func requestBookList(url: String, complete:  @escaping (Array<Dictionary<String, Any>>?, Bool, Error?) -> Swift.Void)  {
        
        //Todo CRUDMethod
        
        isLoading = true
        
        sessionTask = session.dataTask(with: URL.init(string: url)!, completionHandler: {[unowned self] (data, response, error) in
            
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject
                    let response = responseObject["searchResult"] as AnyObject
                    let results = response as? Array<Dictionary<String, Any>>
                    
                    complete(results, true, nil)
                    self.isLoading = false
                    
                } catch {
                    
                }
                
            })
        
        sessionTask.resume()
    
}
}
