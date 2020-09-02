//
//  ProductViewModel.swift
//  IntactTest
//
//  Created by Sasan Baho on 2020-08-27.
//  Copyright © 2020 Sasan Baho. All rights reserved.
//

import Foundation

public class ProductViewModel {
    var productDelegate: ProductDelegate
    
    init(productDelegate: ProductDelegate) {
        self.productDelegate = productDelegate
    }
    //Temp API URL
    private let productURL = "https://sasanbaho.com/api/default.json"
    
    //Fetch products
    func getProducts(){
        if let url = URL(string: productURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, res, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parsJSON(productData: safeData)
                }
            }
            task.resume()
        }
    }
    
    //Pars JSON data
    func parsJSON(productData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ProductsData.self, from: productData)
            //send data to main view
            productDelegate.onDataCalledSuccess(products: decodedData.products)
        }catch {
            print(error)
        }
    }
    
    
    
}
