//
//  ViewController.swift
//  AnyangEbook
//
//  Created by imac27 on 2016. 12. 13..
//  Copyright © 2016년 roi. All rights reserved.
//

import UIKit

public enum CellType: Int {
    case list, collection
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public enum Menu {
        case setting, QR, pdf
    }
    
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var collectionTableView: UITableView!
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var bookAPI = AYBookAPI(listPage: 1, listCount: 9, collectionPage: 1, collectionCount: 12, isListEndPage: false, isCollectionEndPage: false)
    
    public var bookListViewModel: AYBookListViewModel?
    public var bookCollectionViewModel: AYBookCollectionViewModel?
    public var endPoint = EndPoint.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.delegate = self
        listView.dataSource = self
        
        collectionTableView.delegate = self
        collectionTableView.dataSource = self
    
        listView.register(UINib.init(nibName: "AYBookListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        collectionTableView.register(UINib.init(nibName: "AYCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "collectionCell")
        
        bookListViewModel = AYBookListViewModel.init(endPoint: endPoint)
        bookCollectionViewModel = AYBookCollectionViewModel.init(endPoint: endPoint)
        
        self.requestTable(bookAPI)
        collectionTableView.isHidden = true
        listView.isHidden = false
        
        // Do any additional setup after loading the view, typically from a nib.
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
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewController") as! AYPDFViewController
            
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }

// MARK - Request
    func requestTable(_ api: AYBookAPI) {
        
        if api.isListEndPage == false {
            bookListViewModel?.request(pageNumber: api.listPage, itemCount: api.listCount, completionHandler: { [unowned self](isSuccess) in
                DispatchQueue.main.async {
                    if isSuccess {
                    self.listView.reloadData()
                    }
                    
                }
            })
        }
    }
    
     func requestCollection(_ api: AYBookAPI) {
        if api.isCollectionEndPage == false {
            bookCollectionViewModel?.request(pageNumber: api.collectionPage, itemCount: api.collectionCount, completionHandler: {[unowned self] (isSuccess) in
                DispatchQueue.main.async {
                    
                    if isSuccess {
                        self.collectionTableView.reloadData()
                    }
                    
                }
            })
        }
    }
    
// MARK - TableView Method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == listView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? AYBookListTableViewCell
                cell?.setup(book: (bookListViewModel?.bookList[indexPath.row])!)
            return cell!

        } else {

        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as? AYCollectionTableViewCell
            cell?.setup(books: (bookCollectionViewModel?.bookCollection[indexPath.row])!)
            cell?.leftBtn.addTarget(self, action: #selector(pushItemToDetailView(_:)), for: .touchUpInside)
            cell?.midBtn.addTarget(self, action: #selector(pushItemToDetailView(_:)), for: .touchUpInside)
            cell?.rightBtn.addTarget(self, action: #selector(pushItemToDetailView(_:)), for: .touchUpInside)
        
            cell?.leftBtn.cellIndex = indexPath.row
            cell?.rightBtn.cellIndex = indexPath.row
            cell?.midBtn.cellIndex = indexPath.row
            
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
                self.navigationController?.pushViewController(detailViewController!, animated: true)
        case collectionTableView:
            
            break
        default:
            break
        }
    }
    
    @objc func pushItemToDetailView(_ sender: UIButtonSubClassing) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as? AYDetailViewController
        
        detailViewController?.book = bookCollectionViewModel?.bookCollection[sender.cellIndex][sender.horizontalIndex]
        
        self.navigationController?.pushViewController(detailViewController!, animated: true)
    }
    
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
        
//        let sourceViewHeight = scrollView.contentOffset.y + scrollView.frame.size.height
//        let contentSize = scrollView.contentSize.height + CGFloat(100.0)
//
//        if sourceViewHeight < contentSize {
//            switch scrollView {
//
//            case listView:
//             requestTable(bookAPI.increaseParameter(type: .list))
//
//            case collectionTableView:
//                requestCollection(bookAPI.increaseParameter(type: .collection))
//
//            default:
//                break
//            }
//
//        }
        
}

    // MARK - Button Method
    @IBAction func modalAllMenu(_ sender: Any) {
    
    }
    
    @IBAction func selectCollectionMode(_ sender: Any) {
        
        listView.isHidden = true
        collectionTableView.isHidden = false

        if bookCollectionViewModel?.bookCollection.count == 0 {
            requestCollection(bookAPI)
        }
        
    }
    
    @IBAction func selectTableMode(_ sender: Any) {
        
        listView.isHidden = false
        collectionTableView.isHidden = true

    }
    
    @IBAction func pushSettingMenu(_ sender: Any) {
        
        self.pushMenu(.setting)
        
    }

    @IBAction func pushQRMenu(_ sender: Any) {
        
        self.pushMenu(.QR)
        
    }
    
    @IBAction func modalShareMenu(_ sender: Any) {
    
    }
    
}


