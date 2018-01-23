//
//  AYBookCollectionViewCell.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 1. 19..
//  Copyright © 2018년 roi. All rights reserved.
//

import UIKit

class AYBookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    func setup(book: Book) {
        
        thumbnail.sd_setImage(with: URL.init(string: book.thumbnailURL)!, placeholderImage: nil, options: .continueInBackground) { (image, error, cachetype, url) in
            
        }
        
        title.text = book.title
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
