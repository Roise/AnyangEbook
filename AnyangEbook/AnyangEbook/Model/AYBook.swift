//
//  AYBook.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 1. 12..
//  Copyright © 2018년 roi. All rights reserved.
//

import Foundation

struct Book {
    let categoryCode: Int
    let carTagCode: String
    let title: String
    let infoShelf: String
    let date: String
    let thumbnailURL: String
    let fileURL: String
    let fileXML: String
    let firstside: String
    let authorInfo: String
    let dateInfo: String
    let badge: String
    let chapter: Array<Dictionary<String, String>>
    let ebookQRURL: String
    let ebookQR2URL: String
    let bookType: String
}





 //"searchResult": [
//"category_code": "40064",
//"cat_tag_code": "",
//"title": "Vol.266 (2018. 01월)",
//"INFO_SHELF": "",
//"date": "2017-12-27",
//"thumbnail": "http://azine.kr/m/data/1514380108_1.png",
//"file": "http://azine.kr/m/data/1514380108_4.pdf",
//"file_t": "",
//"file_x": "http://azine.kr/m/data/1514380227.xml",
//"firstside": "",
//"info_author": "",
//"info_date": "",
//"badge": "",
//"chapter": [
//{
//"title": "안양에 꿈을 더하다 - 제2의 안양 부흥",
//"page": "4"
//},
//{
//"title": "인문도시 안양",
//"page": "18"
//},
//{
//"title": "삶, 사랑 그리고 사람",
//"page": "26"
//},
//{
//"title": "더 좋은 안양",
//"page": "36"
//}
//],
//"ebookQR": "http://azine.kr/m/_api/apiEbookQR.php?c=107&type=m&m1=40064",
//"ebookQR2": "http://azine.kr/m/_api/apiEbookQR.php?c=107&type=i&m1=40064",
//"bookType": "A"

