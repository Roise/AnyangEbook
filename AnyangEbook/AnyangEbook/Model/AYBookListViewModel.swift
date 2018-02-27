//
//  AYViewModel.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 1. 16..
//  Copyright © 2018년 roi. All rights reserved.
//

import Foundation

class AYBookListViewModel {
    
    var bookList = [Book]()
    var endpoint: EndPoint
    
    init(endPoint: EndPoint) {
        endpoint = endPoint
    }

    public func request(pageNumber: Int, itemCount: Int, completionHandler:@escaping(Bool)->Swift.Void) {
        endpoint.pageNumber = pageNumber
        endpoint.itemCount = itemCount

        if AYNetworkManager.sharedInstance.isLoading {
            return
        }
        
            AYNetworkManager.sharedInstance.requestBookList(url: endpoint.URLString) { [unowned self] (results, isSuccess, error) in
                
                if isSuccess {
                    for data in results! {
                        self.bookList.append((self.binding(data: data)))                        
                    }
                    completionHandler(true)
                } else {
                    print("network failed")
                    completionHandler(false)
                }                
            }
    }
    
    private func binding(data: Dictionary<String, Any>) -> Book {
        
        let book = Book.init(categoryCode: data["category_code"] as! String, carTagCode: data["cat_tag_code"] as! String, title: data["title"] as! String, infoShelf: data["INFO_SHELF"] as! String, date: data["date"] as! String,
                             thumbnailURL: data["thumbnail"] as! String, fileURL: data["file"] as! String, fileXML: data["file_x"] as! String, firstside: data["firstside"] as! String, authorInfo: data["info_author"] as! String, dateInfo: data["info_date"] as! String,
                             badge: data["badge"] as! String, chapter: data["chapter"] as! Array<Dictionary<String, Any>>, ebookQRURL: data["ebookQR"] as! String, ebookQR2URL: data["ebookQR2"] as! String, bookType: data["bookType"] as! String)
        return book
    }
    
}

