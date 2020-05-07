//
//  Grid.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 5/7/20.
//  Copyright © 2020 Ayan Kurmanbay. All rights reserved.
//

import UIKit

struct Grid {
    let cols: CGFloat
    let rows: CGFloat
    
    init(cols: Int, rows: Int) {
        self.cols = CGFloat(cols)
        self.rows = CGFloat(rows)
    }
    
    func size() -> Int {
        return Int(cols * rows)
    }
    
    func string() -> String {
        return "\(Int(rows)) x \(Int(cols))"
    }
}
