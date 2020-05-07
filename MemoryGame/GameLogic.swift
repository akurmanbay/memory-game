//
//  GameLogic.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/23/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

class GameLogic {
    
    // MARK: - Properties
    private var foundItems: Int = 0 {
        didSet {
            didChangeNumberOfMatches?(foundItems)
        }
    }
    private let numberOfDuplicates: Int
    private var selectedItems = [(item: Product, indexPath: IndexPath)]()
    private var selectedIndexPaths: [IndexPath] = []
    
    var didChangeNumberOfMatches: ((Int) -> ())?
    var didNotMatch: (([IndexPath]) -> ())?

    // MARK: - Lifecycle
    init(numberOfDuplicates: Int) {
        self.numberOfDuplicates = numberOfDuplicates
    }
    
    // MARK: - Public
    func add(item: Product, atPosition indexPath: IndexPath) {
        selectedItems.append((item, indexPath))
        
        if selectedItems.count % numberOfDuplicates == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.check()
            }
        }
    }

    // MARK: - Private
    private func check() {
        var openItems = [(item: Product, indexPath: IndexPath)]()
        for _ in 0..<numberOfDuplicates {
            guard let firstElement = selectedItems.first else { return }
            selectedItems.removeFirst()
            openItems.append(firstElement)
        }
        checkForSimilarity(items: openItems)
    }
    
    // MARK: - Check for uniqueness by using Set
    private func checkForSimilarity(items: [(item: Product, indexPath: IndexPath)]) {
        let productIds = items.map { $0.item.image.src }
        let uniqueElements = Set(productIds)
        if uniqueElements.count > 1 {
            let selectedIndexes = items.map { $0.indexPath }
            didNotMatch?(selectedIndexes)
        } else {
            foundItems += 1
        }
    }
    
}
