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

    @IBOutlet weak var progressView: UIProgressView!
    
    public enum Menu {
        case setting, QR, pdf
    }
    
    @IBOutlet weak var listView: UITableView!
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var bookAPI = AYBookAPI(listPage: 1, listCount: 9, collectionPage: 1, collectionCount: 12, isListEndPage: false, isCollectionEndPage: false)
    
    public var bookListViewModel: AYBookListViewModel?
    public var bookCollectionViewModel: AYBookCollectionViewModel?
    public var endPoint = EndPoint.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.register(UINib.init(nibName: "AYBookListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        //collectionTableView.register(UINib.init(nibName: "AYCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "collectionCell")
        bookListViewModel = AYBookListViewModel.init(endPoint: endPoint)
        bookCollectionViewModel = AYBookCollectionViewModel.init(endPoint: endPoint)
        
        listView.isHidden = false
        
//        // default is darkGray
//        SKActivityIndicator.spinnerColor(UIColor.darkGray)
//
//        // default is black
//        SKActivityIndicator.statusTextColor(UIColor.black)
//
//        // default is System Font
//        let myFont = UIFont(name: "AvenirNext-DemiBold", size: 18)
//        SKActivityIndicator.statusLabelFont(myFont!)
//        SKActivityIndicator.spinnerStyle(.spinningFadeCircle)
        
        listView.delegate = self
        listView.dataSource = self
        
        AYNetworkManager.sharedInstance.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.requestTable(bookAPI)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
//            viewController = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewController") as! AYPDFViewController
            
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
    
    @IBAction func selectCollectionMode(_ sender: Any) {
        
        listView.isHidden = true
        
        if bookCollectionViewModel?.bookCollection.count == 0 {
            requestCollection(bookAPI)
        }
        
    }
    
//    @objc func pushItemToDetailView(_ sender: UIButtonSubClassing) {
//        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as? AYDetailViewController
//
//        detailViewController?.book = bookCollectionViewModel?.bookCollection[sender.cellIndex][sender.horizontalIndex]
//
//        self.navigationController?.pushViewController(detailViewController!, animated: true)
//    }
    
    func moreList(_ type: CellType, page: Int, count: Int ) {
        
        switch type {
            
        case .list:
            requestTable(bookAPI)
            
        case .collection:
            requestCollection(bookAPI)
            
        default: break
            
        }
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

extension MainViewController: AYNetworkManagerDelegate {
 
    // MARK - AYNetworkManager delegate Method
    
    func estimateDownloadDataBytes(_ didWriteBytes: Int64, totalBytesExpectedToWrite: Int64) {
        let downloadRatio = Float(didWriteBytes) / Float(totalBytesExpectedToWrite)
        
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
    
    

}

// Extension TableView
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK - TableView Method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == listView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? AYBookListTableViewCell
            cell?.setup(book: (bookListViewModel?.bookList[indexPath.row])!)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == listView {
            return (bookListViewModel?.bookList.count)!
        } else {
            return (bookCollectionViewModel?.bookCollection.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == listView {
            return 100
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as? AYDetailViewController
        
        switch tableView {
        case listView:
            detailViewController?.book = bookListViewModel?.bookList[indexPath.row]
            AYNetworkManager.sharedInstance.downloadPDF(url: (bookListViewModel?.bookList[indexPath.row].fileURL)!)
        default:
            break
        }
    }
    
}


