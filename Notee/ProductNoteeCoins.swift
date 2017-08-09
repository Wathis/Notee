//
//  ProductShop.swift
//  Notee
//
//  Created by Mathis Delaunay on 09/08/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class ProductNoteeCoins  {
    
    var price : String!
    var noteeCoins : String!
    var appleId : String!
    
    init(appleId : String, price : String, noteeCoins : String) {
        self.appleId = appleId
        self.price = price
        self.noteeCoins = noteeCoins
    }
    
}
