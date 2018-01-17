//
//  AYBook.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 1. 12..
//  Copyright © 2018년 roi. All rights reserved.
//

import Foundation

struct Book {
    let categoryCode: String    // 책 상세 페이지
    let carTagCode: String
    let title: String           // 책 버전, 날짜 정보
    let infoShelf: String
    let date: String            // 날짜
    let thumbnailURL: String    // 썸네일 이미지
    let fileURL: String         // pdf파일 url
    let fileXML: String
    let firstside: String
    let authorInfo: String
    let dateInfo: String
    let badge: String           // new 표시
    let chapter: Array<Dictionary<String, Any>> // ChapterData(페이지, 타이틀)
    let ebookQRURL: String
    let ebookQR2URL: String
    let bookType: String
}


//    public String badge;           // new 표시
//    public String pdfFile;         // pdf 파일
//    public String thumbnailImg;    // 썸네일 이미지
//    public String title;
//    public String date;
//    public String categoryCode;    // 책 상세 페이지
//    public String chapterData;     // ChapterData(페이지, 타이틀)
//
//    public String TOC;  // 안씀
//    public String cover_type; // 안씀
//    public String firstside; // 안씀
//    public String index; // 안씀
//    public String info_author; // 안씀
//    public String info_date; // 안씀

/**
 * 1권
 {"info_author":"","cat_tag_code":"","bookType":"A","date":"2016-08-25","info_date":"","file_t":"",
 "chapter":[{"page":"4","title":"새록새록, 안양에서"},{"page":"18","title":"속닥속닥, 골목마다"},{"page":"26","title":"알음알음, 모두의 노래"},{"page":"36","title":"초롱초롱, 삶의 씨앗"},{"page":"44","title":"쓰담쓰담, 꿈의 포옹"}],
 "title":"Vol.250 (2016. 9월)",
 "thumbnail":"http:\/\/azine.kr\/m\/data\/1472087540_1.png",
 "file_x":"http:\/\/azine.kr\/m\/data\/1472087624.xml",
 "firstside":"",
 "file":"http:\/\/azine.kr\/m\/data\/1472087624_4.pdf",
 "INFO_SHELF":"",
 "ebookQR":"http:\/\/azine.kr\/m\/_api\/apiEbookQR.php?c=107&type=m&m1=35919",
 "badge":"new",
 "category_code":"35919",
 "ebookQR2":"http:\/\/azine.kr\/m\/_api\/apiEbookQR.php?c=107&type=i&m1=35919"},
 */


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

