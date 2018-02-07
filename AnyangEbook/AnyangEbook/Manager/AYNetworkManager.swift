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

protocol AYNetworkManagerDelegate: NSObjectProtocol {
    func estimateDownloadDataBytes(_ didWriteBytes: Int64, totalBytesExpectedToWrite: Int64)
    func finishDownloadData(to location: URL)
}

class AYNetworkManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    static let sharedInstance = AYNetworkManager()
    private var sessionTask = URLSessionDataTask()
    public var downloadTask = URLSessionDownloadTask()
    public var session: URLSession?
    public var isLoading = false
    
    public var delegate: AYNetworkManagerDelegate?
 
    var bytesWritten: Int64 = 0
    var totalBytesExpectedToWrite: Int64 = 0
    var finishDownloadLocation: URL?
   
    override init() {
        super.init()
        session = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    public func downloadPDF(url: String) {
        
        downloadTask = (session?.downloadTask(with: URLRequest.init(url: URL.init(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)))!
        let fileURL = url
        let splitURL = fileURL.split(separator: "/")
        let pdfFileName = splitURL[((splitURL.endIndex)-1)]
        let mainBundle = Bundle.main.bundlePath
        
            do {
                let data = try Data.init(contentsOf: URL.init(string: url)!)
                //let fileURL = self.createdDataPathURL(fileName)!
                
                if FileManager.default.createFile(atPath: mainBundle + pdfFileName, contents: data, attributes: nil) {
                    
                    //completionHandler(data, URL.init(fileURLWithPath: mainBundle + fileName), error)
                } else {
                    print("error")
                }
            } catch {

            }
        
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
        
        sessionTask = (session?.dataTask(with: URL.init(string: url)!, completionHandler: {[unowned self] (data, response, error) in
            
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject
                let response = responseObject["searchResult"] as AnyObject
                let results = response as? Array<Dictionary<String, Any>>
                
                complete(results, true, nil)
                
                self.isLoading = false
                
            } catch {
                
            }
            
        }))!
        sessionTask.resume()
}
    
//MARK - URLSession Delegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if delegate != nil {
            delegate?.finishDownloadData(to: location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if delegate != nil {
            delegate?.estimateDownloadDataBytes(totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        }
        
    }

}
