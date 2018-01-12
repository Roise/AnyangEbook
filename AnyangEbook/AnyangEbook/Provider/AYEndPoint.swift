//
//  File.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 1. 11..
//  Copyright © 2018년 roi. All rights reserved.
//

import Foundation

enum CRUDMethod {
    case get
    case post
    case put
    case update
}

struct EndPoint {
    
    private let baseURL = "http://azine.kr/m/_api/apiEbook.php?code=107&"
    var pageNumber = 0
    var path: String {
            return baseURL + "page=" + "\(pageNumber)" + "&cnt=9&grid=0&t="
    }
}

extension EndPoint {
    
    var URLString: String {
        return path
    }
    
}
