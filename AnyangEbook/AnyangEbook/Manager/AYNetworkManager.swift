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
 //   func finishDownloadData(book: Book)
    func finishDownloadData(to location: String)
}

class AYNetworkManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    static let sharedInstance = AYNetworkManager()
    private var sessionTask = URLSessionDataTask()
    public var downloadTask = URLSessionDownloadTask()
    public var session: URLSession?
    public var isLoading = false
    public var finishedFliePath: String?
    public var delegate: AYNetworkManagerDelegate?
    public var selectedBook: Book?
    
    var bytesWritten: Int64 = 0
    var totalBytesExpectedToWrite: Int64 = 0
    var finishDownloadLocation: URL?
   
    override init() {
        
        super.init()
        session = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
    
    }
    
    public func downloadPDF(book: Book) {
        selectedBook = book
        let url = selectedBook?.fileURL
        downloadTask = (session?.downloadTask(with: URLRequest(url: URL(string: url!)!,
                                                                    cachePolicy: .useProtocolCachePolicy,
                                                                    timeoutInterval: 60)))!
        let splitURL = url?.split(separator: "/")
        let pdfFileName = splitURL![((splitURL?.endIndex)!-1)]
        finishedFliePath = createdDataDirectoryPath(String(pdfFileName))
        
        downloadTask.resume()
    }
    
    private func createdDataDirectoryPath(_ fileName: String) -> String? {
        
        let bundleID = Bundle.main.bundleIdentifier
        let fileManager = FileManager.default
        var dirPath: URL?
        var appSupportDir = [URL]()
        
        appSupportDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if appSupportDir.count > 0
        {
            dirPath = appSupportDir[0].appendingPathComponent(bundleID!)
        }
        
        
        do {            
            try fileManager.createDirectory(atPath: (dirPath?.path)!, withIntermediateDirectories: true, attributes: nil)
            let filePath = (dirPath?.path)! + fileName
            return filePath
        } catch let error {
            print("\(error.localizedDescription)")
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
        
        do
        {
            let data = try Data.init(contentsOf: location)
            selectedBook?.downloadBookData = data
         //   delegate?.finishDownloadData(book: selectedBook!)
            FileManager.default.createFile(atPath: finishedFliePath!, contents: data, attributes: nil)
            delegate?.finishDownloadData(to: finishedFliePath!)
        } catch let error {
            print("copying error \(error.localizedDescription)")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if delegate != nil {
            delegate?.estimateDownloadDataBytes(totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        }
        
    }

}
