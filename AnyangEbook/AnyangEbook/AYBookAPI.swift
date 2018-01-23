//
//  AYBookAPI.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 1. 11..
//  Copyright © 2018년 roi. All rights reserved.
//

import Foundation

struct AYBookAPI {
    var listPage: Int
    var listCount: Int
    var collectionPage: Int
    var collectionCount: Int
    var isListEndPage: Bool
    var isCollectionEndPage: Bool

}

extension AYBookAPI {
    mutating func increaseParameter(type: CellType) -> AYBookAPI{
        
        switch type {
            
        case .list:
            self.listPage+=1
            self.listCount+=3
            
            if listPage == 3 {
                isListEndPage = true
            } else {
                isListEndPage = false
            }
            
            return self
            
        case .collection:
            self.collectionPage+=1
            self.collectionCount+=6
            
            if collectionPage == 3 {
                isCollectionEndPage = true
            } else {
                isListEndPage = false
            }
            
            return self
            
        default:
            break
        }
    }
}
