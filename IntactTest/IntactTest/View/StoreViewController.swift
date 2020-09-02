//
//  ViewController.swift
//  IntactTest
//
//  Created by Sasan Baho on 2020-08-27.
//  Copyright © 2020 Sasan Baho. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController , ProductDelegate{
    
    
    var list : [Products] = []
    var wishList: [Products] = []
    lazy var productViewModel = { [unowned self] in ProductViewModel (productDelegate: self)} ()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SubTotal: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTableView()
        initializer()
        productViewModel.getProducts()
        
    }
    
    func initializer() {
        SubTotal.text = "0"
        checkoutButton.layer.cornerRadius = 5
    }
    
    //Add the data to the list and update cataloge collection view
    func onDataCalledSuccess(products: [Products]) {
        list = products
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // Add the data to the wish list array and update wish list table view
    func onAddedToWishList(product: Products, index: Int) {
        if product.isAddedToWishList == false {
            wishList.remove(at: index)
            tableView.reloadData()
            calculateSubTotal()
        }else{
            wishList.append(product)
            tableView.reloadData()
            calculateSubTotal()
        }
        
    }
    
    //Set up wish list table view
    func setupTableView() {
        tableView.register(WishListTableViewCell.nib(), forCellReuseIdentifier: WishListTableViewCell.identifier)
        tableView.rowHeight = 130.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    //Set up product cataloge collection view
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.register(ProductCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .none
    }
    
    //Calculate subtotal of wish list items
    func calculateSubTotal(){
        var total:Float = 0
        if wishList.count == 0 {
            total = 0
            SubTotal.text = "0"
        }else {
            for price in wishList {
                total = total + Float(price.price)
                SubTotal.text = "$\(total)"
            }
        }
    }
    
    //Create label for showing product colors
    static func createColorLabel(colorContainer: UIView, product: Products) {
        var xposition = 0
        for view in colorContainer.subviews {
            view.removeFromSuperview()
        }
        if let colors = product.colors {
            for i in 0...colors.count-1 {
                let color = colors[i]
                let label = UILabel.init()
                label.frame = CGRect(x: xposition, y: 0, width: 25, height: 25)
                label.backgroundColor = UIColor(hexString: color.code)
                colorContainer.addSubview(label)
                xposition += 30
            }
        }
    }
    
    //Checkout alert
    func showAlert() {
            if wishList.count == 0 {
            let alert = UIAlertController(title: "Your wish list is empty", message: "Please add a product to your wish list first!", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else {
            let alert = UIAlertController(title: "Are you sure you want to procced to checkout?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {action in
                self.wishList.removeAll()
                self.tableView.reloadData()
                self.SubTotal.text = "0"
            }))
            self.present(alert, animated: true)
        }
    }
    
    //unwind from product detail view
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }

    @IBAction func checkOutButton(_ sender: UIButton) {
        showAlert()
    }

}


// MARK: - Collection view data source

extension StoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        showItemView(item: list[indexPath.row], index: indexPath.row)
    }
    
    // Send data to Product detail view
    public func showItemView(item: Products, index: Int) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "productDetailView") as! ProductDetailViewController
        itemVC.item = item
        itemVC.itemIndex = index
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
}

extension StoreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        let urlString = list[indexPath.row].image
        let url = NSURL(string: urlString)! as URL
        if let imageData: NSData = NSData(contentsOf: url) {
            cell.configure(with: UIImage(data: imageData as Data)!, name: list[indexPath.row].brand )
        }
        return cell
    }
    
}

extension StoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 140)
    }
}

// MARK: - Table view data source

extension StoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishList.count
    }
}

extension StoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WishListTableViewCell.identifier , for: indexPath) as! WishListTableViewCell
        let wishListItem = wishList[indexPath.row]
        let urlString = wishListItem.image
        let url = NSURL(string: urlString)! as URL
        
        
        if let imageData: NSData = NSData(contentsOf: url) {
            cell.configure(with: UIImage(data: imageData as Data)!, price: wishListItem.price, title: wishListItem.title, description: wishListItem.description, outOfStuck: wishListItem.quantity == 0 ? "Out of stuck" : "" )
        }
        StoreViewController.createColorLabel(colorContainer: cell.colorContainerView, product: wishListItem)
        cell.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        cell.accessoryType = .disclosureIndicator
        
        // Make selected cell background color white
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showItemView(item: wishList[indexPath.row], index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your wish list:"
    }
    
    
}

// MARK: - Transform String to hex color
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
