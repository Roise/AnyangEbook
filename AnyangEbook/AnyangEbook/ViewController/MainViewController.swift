//
//  ViewController.swift
//  AnyangEbook
//
//  Created by imac27 on 2016. 12. 13..
//  Copyright © 2016년 roi. All rights reserved.
//

import UIKit
import M13PDFKit

public enum CellType: Int {
    case list, collection
}

class MainViewController: UIViewController {
    
    public enum Menu {
        case setting, QR, pdf
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var progressView: BRCircularProgressView!
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var bookAPI = AYBookAPI(listPage: 1, listCount: 9, collectionPage: 1, collectionCount: 12, isListEndPage: false, isCollectionEndPage: false)
    
    public var bookListViewModel: AYBookListViewModel?
    public var bookCollectionViewModel: AYBookCollectionViewModel?
    public var endPoint = EndPoint.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.register(UINib.init(nibName: "AYBookListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        collectionView.register(UINib.init(nibName: "AYBookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        bookListViewModel = AYBookListViewModel.init(endPoint: endPoint)
        //bookCollectionViewModel = AYBookCollectionViewModel.init(endPoint: endPoint)
        
        listView.isHidden = false
        collectionView.isHidden = true
        
        let collectionWidth = (((self.view.bounds.width - 30) - 20) / 2)
        let collectionLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionLayout?.itemSize = CGSize(width: collectionWidth, height: 270)
        
        // default is darkGray
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        
        // default is black
        SKActivityIndicator.statusTextColor(UIColor.black)
        
        // default is System Font
        let myFont = UIFont(name: "AvenirNext-DemiBold", size: 18)
        SKActivityIndicator.statusLabelFont(myFont!)
        SKActivityIndicator.spinnerStyle(.spinningFadeCircle)
        
        listView.delegate = self
        listView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        progressView.isHidden = true
        
        AYNetworkManager.sharedInstance.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.requestTable(bookAPI)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.progressView.progress = 0
        self.progressView.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func pushMenu(_ menu: Menu) {
        
        var viewController = UIViewController()
        
        switch menu {
            
        case .setting:
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! AYSettingViewController
            
        case .QR:
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "QRViewControllerID") as! AYQRViewController
            
        case .pdf:
            break
            
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    // MARK - Request
    func requestTable(_ api: AYBookAPI) {
        
        if api.isListEndPage == false {
            SKActivityIndicator.show("Loading..")
            bookListViewModel?.request(pageNumber: api.listPage, itemCount: api.listCount, completionHandler: { [unowned self](isSuccess) in
                DispatchQueue.main.async {
                    self.listView.reloadData()
                    self.collectionView.reloadData()
                    SKActivityIndicator.dismiss()
                }
            })
        }
    }
    
    func requestCollection(_ api: AYBookAPI) {
        
        if api.isCollectionEndPage == false {
            
        }
    }
    
    @IBAction func selectTableMode(_ sender: Any) {
        
        listView.isHidden = false
        collectionView.isHidden = true
        
        if bookListViewModel?.bookList.count == 0 {
            requestTable(bookAPI)
        }
        
    }
    
    @IBAction func selectCollectionMode(_ sender: Any) {
        
        listView.isHidden = true
        collectionView.isHidden = false
        
        if bookListViewModel?.bookList.count == 0 {
            requestTable(bookAPI)
        }
        
    }
    
    @IBAction func pushSettingMenu(_ sender: Any) {
        
        self.pushMenu(.setting)
        
    }
    
    @IBAction func pushQRMenu(_ sender: Any) {
        
        self.pushMenu(.QR)
        
    }
    
    @IBAction func modalShareMenu(_ sender: Any) {
        
    }
    @IBAction func pushLibrary(_ sender: Any) {
        
        let libraryViewController = AYLibraryViewController()
        self.navigationController?.pushViewController(libraryViewController, animated: true)
        
    }
    
    // MARK - Button Method
    @IBAction func modalAllMenu(_ sender: Any) {
        
    }
    
    //    @objc func pushItemToDetailView(_ sender: UIButtonSubClassing) {
    //        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as? AYDetailViewController
    //
    //        detailViewController?.book = bookCollectionViewModel?.bookCollection[sender.cellIndex][sender.horizontalIndex]
    //
    //        self.navigationController?.pushViewController(detailViewController!, animated: true)
    //    }
    
    func moreList(_ type: CellType, page: Int, count: Int ) {
        
        requestTable(bookAPI)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let sourceViewHeight = scrollView.contentOffset.y + scrollView.frame.size.height
        let contentSize = scrollView.contentSize.height + CGFloat(100.0)
        
        if sourceViewHeight < contentSize {
            if AYNetworkManager.sharedInstance.isLoading == false {
                requestTable(bookAPI.increaseParameter(type: .list))
            }
        }
    }
}

// MARK - AYNetworkManager delegate Method

extension MainViewController: AYNetworkManagerDelegate {
    
//    func finishDownloadData(book: Book) {
//        //AYCoreDataManager.shared.addBook(book: book)
//    }
    
    func estimateDownloadDataBytes(_ didWriteBytes: Int64, totalBytesExpectedToWrite: Int64) {
        showProgressView(didWriteBytes, totalBytes: totalBytesExpectedToWrite)
    }
    
    func startDataTask(_ didWriteBytes: Int64, totalBytes: Int64) {
        
    }
    
    func finishDownloadData(to location: String) {

        DispatchQueue.main.async {
            let document: PDFKDocument = PDFKDocument(contentsOfFile: location, password: nil)
            let viewer = PDFKBasicPDFViewer.init(document: document)!
            viewer.loadDocument(document)
            viewer.enableBookmarks = true
            viewer.enableThumbnailSlider = true

            self.addChildViewController(viewer)
            self.navigationController?.pushViewController(viewer, animated: true)
        }

    }
    
    func showProgressView(_ didWriteBytes: Int64, totalBytes: Int64) {
        
        let progressRatio = CGFloat(didWriteBytes) / CGFloat(totalBytes)
        print(progressRatio)
        progressView.progress = progressRatio
    
    }
    
}

//MARK - Extension Collectionview
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (bookListViewModel?.bookList.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? AYBookCollectionViewCell
        cell?.setupCell(with: (bookListViewModel?.bookList[indexPath.row])!)
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as? AYDetailViewController
        let book = bookListViewModel?.bookList[indexPath.row]
        detailViewController?.book = book
        let alertController = UIAlertController.init(title: "Download", message: "다운로드를 진행하시겠습니까?", preferredStyle: .actionSheet)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { [unowned self](action) in
            self.progressView.setCircleStrokeWidth(5)
            self.progressView.progress = 0
            self.progressView.isHidden = false
            AYNetworkManager.sharedInstance.downloadPDF(book: book!)
        }
        let cancleAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancleAction)
        
        self.present(alertController, animated: true)
    }
}

//MARK - Extension TableView
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? AYBookListTableViewCell
        cell?.setup(book: (bookListViewModel?.bookList[indexPath.row])!)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bookListViewModel?.bookList.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == listView {
            return 100
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as? AYDetailViewController
        let selectedBook = bookListViewModel?.bookList[indexPath.row]
        detailViewController?.book = selectedBook
        
        let alertController = UIAlertController(title: "Download", message: "다운로드를 진행하시겠습니까?", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self](action) in
            self.progressView.setCircleStrokeWidth(5)
            self.progressView.progress = 0
            self.progressView.isHidden = false
            AYNetworkManager.sharedInstance.downloadPDF(book: selectedBook!)
        }
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancleAction)
        
        self.present(alertController, animated: true)
    }
    
}



