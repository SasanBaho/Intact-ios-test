//
//  ProductDetailViewController.swift
//  IntactTest
//
//  Created by Sasan Baho on 2020-08-29.
//  Copyright © 2020 Sasan Baho. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var item : Products?
    var itemIndex: Int?
    var productRate: Int?
    
    @IBOutlet weak var colorUIView: UIView!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var sizeHLabel: UILabel!
    @IBOutlet weak var sizeWLabel: UILabel!
    @IBOutlet weak var sizeDLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ProductImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToWishList: UIButton!
    @IBOutlet weak var HsizeLabel: UILabel!
    @IBOutlet weak var WsizeLabel: UILabel!
    @IBOutlet weak var DsizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI ()
        ChangeButtonColor()
    }
    
    //Show all the product details in the UI
    func updateUI () {
        priceLabel.text = "$ \(item!.price)"
        let urlString = item!.image
        let url = NSURL(string: urlString)! as URL
        if let imageData: NSData = NSData(contentsOf: url) {
            ProductImageView.image = UIImage(data: imageData as Data)!
        }
        navigationItem.title = item!.brand
        descriptionLabel.text = item!.description
        addToWishList.layer.cornerRadius = 5
        getSize()
        StoreViewController.createColorLabel(colorContainer: self.colorUIView, product: item!)
    }
    
    //Change add to wish list button's background
    func ChangeButtonColor() {
        if item?.isAddedToWishList == false || item?.isAddedToWishList == nil  {
            addToWishList.backgroundColor = UIColor(hexString: "#FF1331")
            addToWishList.setTitle("Add to wish list", for: .normal)
        }else {
            addToWishList.backgroundColor = .black
            addToWishList.setTitle("Remove from wish list", for: .normal)
        }
    }
    
    //Get item sizes
    func getSize(){
        sizeHLabel.text = item?.size.H
        sizeWLabel.text = item?.size.W
        sizeDLabel.text = item?.size.D
    }
    
    //Go back to Main page
    @IBAction func AddToWishListButton(_ sender: UIButton) {
        if item?.isAddedToWishList == false || item?.isAddedToWishList == nil  {
            item?.isAddedToWishList = true
        }else {
            item?.isAddedToWishList = false
        }
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    @IBAction func RateStarButton(_ sender: UIButton) {
        star1.tintColor = .gray
        star2.tintColor = .gray
        star3.tintColor = .gray
        star4.tintColor = .gray
        star5.tintColor = .gray
        
        productRate = sender.tag
        switch productRate {
        case 1:
            star1.tintColor = .yellow
        case 2:
            star1.tintColor = .yellow
            star2.tintColor = .yellow
        case 3:
            star1.tintColor = .yellow
            star2.tintColor = .yellow
            star3.tintColor = .yellow
        case 4:
            star1.tintColor = .yellow
            star2.tintColor = .yellow
            star3.tintColor = .yellow
            star4.tintColor = .yellow
        case 5:
            star1.tintColor = .yellow
            star2.tintColor = .yellow
            star3.tintColor = .yellow
            star4.tintColor = .yellow
            star5.tintColor = .yellow
        default:
            star1.tintColor = .gray
            star2.tintColor = .gray
            star3.tintColor = .gray
            star4.tintColor = .gray
            star5.tintColor = .gray
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMain" {
            guard let vc = segue.destination as? StoreViewController else { return }
            //Send item to main page wish list
            vc.onAddedToWishList(product: item!, index: itemIndex!)
        }
    }
    
}

