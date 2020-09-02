//
//  ProductCollectionViewCell.swift
//  IntactTest
//
//  Created by Sasan Baho on 2020-08-29.
//  Copyright © 2020 Sasan Baho. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    static let identifier = "productCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    public func configure(with image: UIImage, name: String) {
        imageView.image = image
        productNameLabel.text = name
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ProductCollectionViewCell", bundle: nil)
    }

}

