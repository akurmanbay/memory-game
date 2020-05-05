//
//  MainPlaygroundViewModel.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/22/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

class MainPlaygroundViewModel {
    
    let products: [Product]
    
    init(products: [Product]) {
        self.products = products
    }
    
    func getNumberOfPairs() -> Int {
        return products.count / 2
    }
    
    func getGridSize() -> Int {
        return Int(sqrt(Double(products.count)))
    }
    
    func getProduct(at indexPath: IndexPath) -> Product {
        return products[indexPath.row]
    }
}
