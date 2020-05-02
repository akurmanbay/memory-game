//
//  GameLogic.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/23/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

class GameLogic {
    
    private var foundItems: Int = 0 {
        didSet {
            didChangeNumberOfMatches?(foundItems)
        }
    }
    private let numberOfDuplicates: Int
    private var selectedItems: [Product] = []
    private var selectedIndexPaths: [IndexPath] = []
    
    var didChangeNumberOfMatches: ((Int) -> ())?
    var didFoundNotMatch: (([IndexPath]) -> ())?
    var isUserInteractionEnabled: ((Bool) -> ())?
    
    // MARK: - Number of choices that player should make (Currently it is 2)
    init(numberOfDuplicates: Int) {
        self.numberOfDuplicates = numberOfDuplicates
    }
    
    func add(item: Product, atPosition indexPath: IndexPath) {
        selectedItems.append(item)
        selectedIndexPaths.append(indexPath)
        if selectedItems.count == numberOfDuplicates {
            isUserInteractionEnabled?(false)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.checkChoicesIfNeeded()
            self.isUserInteractionEnabled?(true)
        }
    }
    
    private func checkChoicesIfNeeded() {
        if selectedItems.count == numberOfDuplicates {
            if !checkItemsForIdentity() {
                didFoundNotMatch?(selectedIndexPaths)
            }
            clearAll()
        }
    }
    
    private func clearAll() {
        selectedItems.removeAll()
        selectedIndexPaths.removeAll()
    }
    
    // MARK: - Checking for elements of same id (there should be only one unique id)
    private func checkItemsForIdentity() -> Bool {
        for item in selectedItems {
            for ditem in selectedItems {
                if item.image.id != ditem.image.id {
                    return false
                }
            }
        }
        foundItems += 1
        return true
    }
}
