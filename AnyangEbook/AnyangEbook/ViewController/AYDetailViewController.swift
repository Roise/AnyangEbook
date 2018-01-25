//
//  AYDetailViewController.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 1. 24..
//  Copyright © 2018년 roi. All rights reserved.
//

import UIKit
import SDWebImage

class AYDetailViewController: UIViewController {

    public var book: Book?
    
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataSetup()  {
        var description = ""
        
        bookCover.sd_setImage(with: URL.init(string: (book?.thumbnailURL)!), placeholderImage: nil, options: SDWebImageOptions.cacheMemoryOnly) { (image, error, cachetype, url) in
        }
        bookTitle.text = book?.title
        
        for chapter in (book?.chapter)! {
            description+="\(String(describing: chapter["page"])) \(String(describing: chapter["title"])) \n"
        }
        
        bookDescription.text = description
    
    }
    
    //MARK - Method
    
    @IBAction func downloadBookPDF(_ sender: Any) {
    }
    
    @IBAction func viewBookPDF(_ sender: Any) {
    }
    @IBAction func sharePDF(_ sender: Any) {
    }
    @IBAction func popPrev(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
