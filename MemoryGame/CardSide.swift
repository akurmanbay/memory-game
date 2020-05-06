//
//  CardSide.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 5/6/20.
//  Copyright © 2020 Ayan Kurmanbay. All rights reserved.
//

import Foundation

enum CardSide {
    case open, closed
    
    mutating func toggle() {
        self = self == .closed ? .open : .closed
    }
}
