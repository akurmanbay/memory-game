//
//  PickerLogic.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 5/7/20.
//  Copyright © 2020 Ayan Kurmanbay. All rights reserved.
//

import UIKit

protocol PickerLogic: class {
    var reloadComponent: ((Int) -> ())? { get set }
    var didUpdateValues: (() -> ())? { get set }
    
    func numberOfComponents() -> Int
    func numberOfRowsInComponent(_ component: Int) -> Int
    func widthProportionForComponent(_ component: Int) -> CGFloat
    func attributedTitleForRow(_ row: Int, forComponent component: Int) -> NSAttributedString?
    func didSelectRow(_ row: Int, inComponent component: Int)
    func getCurrentValues() -> (Int, Grid)
}

class PickerLogicImpl: PickerLogic {
    
    // MARK: - Properties
    var reloadComponent: ((Int) -> ())?
    var didUpdateValues: (() -> ())?
    private let numberOfDuplicates = Array(2..<6)
    private var grids = [Grid]()
    
    private var currentNumberOfCardsInSet = 2
    private var currentGrid = Grid(cols: 2, rows: 2)
    
    // MARK: - Lifecycle
    init() {
        getAllGridCombinations(for: numberOfDuplicates[0])
        currentNumberOfCardsInSet = numberOfDuplicates[0];
        currentGrid = grids[0]
    }
    
    // MARK: - Public
    func attributedTitleForRow(_ row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
        ]
        var title: String = ""
        if component == 0 {
            title = String(numberOfDuplicates[row])
        } else {
            title = "\(Int(grids[row].rows)) x \(Int(grids[row].cols))"
        }
        return NSAttributedString(string: title,
                                  attributes: attributes)
    }
    
    func numberOfComponents() -> Int {
        return 2
    }
    
    func numberOfRowsInComponent(_ component: Int) -> Int {
        if component == 0 {
            return numberOfDuplicates.count
        }
        return grids.count
    }
    
    func widthProportionForComponent(_ component: Int) -> CGFloat {
        if component == 0 {
            return 0.3
        }
        return 0.7
    }
    
    func didSelectRow(_ row: Int, inComponent component: Int) {
        if (component == 0) {
            getAllGridCombinations(for: numberOfDuplicates[row])
            reloadComponent?(1)
            currentNumberOfCardsInSet = numberOfDuplicates[row]
            currentGrid = grids[0];
        } else {
            currentGrid = grids[row]
        }
        didUpdateValues?()
    }
    
    func getCurrentValues() -> (Int, Grid) {
        return (currentNumberOfCardsInSet, currentGrid)
    }
    
    // MARK: - Private
    private func getAllGridCombinations(for number: Int) {
        grids.removeAll()
        for col in 2..<6 {
            for row in col..<7 {
                let size = col * row
                if (size % number == 0 && size > number) {
                    grids.append(Grid(cols: col, rows: row))
                }
            }
        }
    }
}
