//
//  MainPlaygroundViewModel.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/22/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

class MainPlaygroundViewModel {
    
    // MARK: - Properties
    let playSettings: PlaySettings
    private var products: [Product]
    
    // MARK: - Lifecycle
    init(products: [Product], playSettings: PlaySettings) {
        self.products = products
        self.playSettings = playSettings
    }
    
    // MARK: - Public
    func getNumberOfPairs() -> Int {
        return products.count / playSettings.0
    }
    
    func shuffleProducts() {
        products.shuffle()
    }
    
    func getProduct(at indexPath: IndexPath) -> Product {
        return products[indexPath.row]
    }
}
