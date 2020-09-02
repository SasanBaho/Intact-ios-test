//
//  ProductModel.swift
//  IntactTest
//
//  Created by Sasan Baho on 2020-08-27.
//  Copyright © 2020 Sasan Baho. All rights reserved.
//

import Foundation

struct ProductsData: Decodable  {
    var products: [Products]
}

struct Products : Decodable {
    let id : Int
    let title: String
    let brand : String
    let description: String
    var colors: [Color]?
    let size : Size
    let image: String
    let price: Float
    let quantity: Int
    var isAddedToWishList: Bool? = false
    
}

struct Color : Decodable {
    let name : String
    var code: String
}

struct Size : Decodable {
    let H : String
    let W : String
    let D : String
}
