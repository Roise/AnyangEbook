//
//  File.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 1. 11..
//  Copyright © 2018년 roi. All rights reserved.
//

import Foundation

struct EndPoint {

    private let baseURL = "http://azine.kr/m/_api/apiEbook.php?code=107&"
    public var pageNumber = 0
    public var itemCount = 0
    
    private var path: String {
            return baseURL
        }
}

extension EndPoint {
    
    public var URLString: String {
        return path + "page=" + String(pageNumber) + "cnt=" + String(itemCount) + "&grid=0&t="
    }
    
}
