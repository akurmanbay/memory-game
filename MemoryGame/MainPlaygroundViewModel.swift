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
    let playSettings: PlaySettings
    
    init(products: [Product], playSettings: PlaySettings) {
        self.products = products
        self.playSettings = playSettings
    }
    
    func getNumberOfPairs() -> Int {
        return products.count / playSettings.0
    }
    
    func getProduct(at indexPath: IndexPath) -> Product {
        return products[indexPath.row]
    }
}
