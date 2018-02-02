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
    private var sessionTask = URLSessionDataTask()
    public var downloadTask = URLSessionDownloadTask()
    public let session = URLSession.shared
    
    public var isLoading = false
    
    public func downloadPDF(url: String, fileName: String, completionHandler: @escaping(Data, URL, Error?) -> Swift.Void) {
        
        downloadTask = session.downloadTask(with: URL.init(string: url)!, completionHandler: { (url, response, error) in
                let mainBundle = Bundle.main.bundlePath
            do {
                let data = try Data.init(contentsOf: url!)
                let fileURL = self.createdDataPathURL(fileName)!
                print(fileURL.path)
                print(mainBundle + fileName)
                if FileManager.default.createFile(atPath: mainBundle + fileName, contents: data, attributes: nil) {
                    completionHandler(data, URL.init(fileURLWithPath: mainBundle + fileName), error)
                } else {
                    print("error")
                }
            } catch {
                
            }
        })
        
        downloadTask.resume()
    }
    
    private func createdDataPathURL(_ fileName: String) -> URL? {
        
        let bundleID = Bundle.main.bundleIdentifier
        let fileManager = FileManager.default
        var dirPath: URL?
        var appSupportDir = [URL]()
        
        appSupportDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if appSupportDir.count > 0
        {
            dirPath = appSupportDir[0].appendingPathComponent(bundleID!)
        }
        
        let filePath = (dirPath?.path)! + "/" + fileName
        do {
            try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
            return URL.init(fileURLWithPath: filePath)
        } catch {
            return nil
        }
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
