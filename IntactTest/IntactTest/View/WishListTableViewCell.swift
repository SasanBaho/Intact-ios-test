//
//  WishListTableViewCell.swift
//  IntactTest
//
//  Created by Sasan Baho on 2020-08-29.
//  Copyright © 2020 Sasan Baho. All rights reserved.
//

import UIKit

class WishListTableViewCell: UITableViewCell {
    
    static let identifier = "wishlistCell"
    @IBOutlet weak var wishlishImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var colorContainerView: UIView!
    @IBOutlet weak var outOfStuckLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage, price: Float, title: String, description: String, outOfStuck: String) {
        wishlishImageView.image = image
        priceLabel.text = "$ \(price)"
        titleLabel.text = title
        descriptionLabel.text = description
       // colorContainerView.addSubview(colorContainer)
        outOfStuckLabel.text = outOfStuck
    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        print("Table view cell tapped")
    //    }
    
    static func nib() -> UINib {
        return UINib(nibName: "WishListTableViewCell", bundle: nil)
    }
    
}
