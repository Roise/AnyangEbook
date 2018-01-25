//
//  AYCustomTableViewCell.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 1. 22..
//  Copyright © 2018년 roi. All rights reserved.
//

import UIKit
import SDWebImage

class UIButtonSubClassing: UIButton {
    var horizontalIndex = 0
    var cellIndex: Int = 0
}

class AYCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftCell: UIView!
    @IBOutlet weak var midCell: UIView!
    @IBOutlet weak var rightCell: UIView!
    
    @IBOutlet weak var leftBtn: UIButtonSubClassing!
    @IBOutlet weak var midBtn: UIButtonSubClassing!
    @IBOutlet weak var rightBtn: UIButtonSubClassing!
    public var buttons = [UIButton]()
    
    public func setup(books: [Book]) {
     
        let bookCells = [leftCell, midCell, rightCell]
        leftBtn.horizontalIndex = 0
        midBtn.horizontalIndex = 1
        rightBtn.horizontalIndex = 2
        
        buttons.append(leftBtn)
        buttons.append(midBtn)
        buttons.append(rightBtn)
        
        for i in 0...2 {
            self.setupBookCell(cell: bookCells[i]!, book: books[i])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupBookCell(cell: UIView, book: Book) {
       
        var backGroundImageView: UIImageView?
        var title: UILabel?
        
        backGroundImageView = UIImageView.init(frame: cell.bounds)
        title = UILabel.init(frame: CGRect(x: cell.bounds.origin.x, y: cell.bounds.size.height - 33, width: cell.bounds.size.width, height: 33))
        title?.font = UIFont(name: "Helvetica", size: CGFloat(12))
        title?.numberOfLines = 0
        title?.textColor = UIColor.white
        title?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        title?.text = book.title
        
        backGroundImageView?.sd_setImage(with: URL.init(string: book.thumbnailURL)!, placeholderImage: nil, options: .continueInBackground) { (image, error, cachetype, url) in
            cell.addSubview(backGroundImageView!)
            cell.addSubview(title!)
        }
        
    }
}
