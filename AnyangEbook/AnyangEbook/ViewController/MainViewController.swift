//
//  ViewController.swift
//  AnyangEbook
//
//  Created by imac27 on 2016. 12. 13..
//  Copyright © 2016년 roi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    public enum Menu {
        
        case setting
        
        case QR
        
        case pdf
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    //     public static String BOOK_INFORMATION_URL = "http://azine.kr/m/_api/apiEbook.php?code=107&page=1&cnt=9&gid=0&t=";
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


