//
//  AYBookCollectionViewCell.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 2. 21..
//  Copyright © 2018년 roi. All rights reserved.
//

import UIKit
import SDWebImage

class AYBookCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(with data: Book) {
        title.text = data.title
        thumbnail.sd_setImage(with: URL.init(string: data.thumbnailURL), placeholderImage: nil, options: .cacheMemoryOnly) { (image, error, cacheType, url) in
            
        }
    }

}
