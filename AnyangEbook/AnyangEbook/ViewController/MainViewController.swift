//
//  ViewController.swift
//  AnyangEbook
//
//  Created by imac27 on 2016. 12. 13..
//  Copyright © 2016년 roi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate, UITableViewDataSource, UICollectionViewDataSource {

    public enum Menu {
        
        case setting, QR, pdf
        
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    public var bookListViewModel: AYBookListViewModel?
    public var endPoint = EndPoint.init(pageNumber: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.register(UINib.init(nibName: "AYBookListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        collectionView.register(UINib.init(nibName: "AYBookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionCell")
                
        bookListViewModel = AYBookListViewModel.init(endPoint: endPoint)
        
        self.request()
        
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
    func request() {
        bookListViewModel?.request(pageNumber: 1, completionHandler: {[unowned self] (isSuccess) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    
// MARK - TableView Method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? AYBookListTableViewCell
        
        cell?.setup(book: (bookListViewModel?.bookList[indexPath.row])!)
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bookListViewModel?.bookList.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
// MARK - CollectionView Method
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? AYBookCollectionViewCell
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
// MARK - Button Method
    @IBAction func modalAllMenu(_ sender: Any) {
    }
    
    @IBAction func selectCollectionMode(_ sender: Any) {
        tableView.isHidden = true
        collectionView.isHidden = false
    }
    
    @IBAction func selectTableMode(_ sender: Any) {
        tableView.isHidden = false
        collectionView.isHidden = true
        
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


