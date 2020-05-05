//
//  ImageCache.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/22/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

class ImageCache {
    
    static let shared = ImageCache()
    
    let storage = Cache<String, Data>()
    
    private init() { }
}
