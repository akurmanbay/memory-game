//
//  Product.swift
//  NSURLSession+Codable
//
//  Created by Ayan Kurmanbay on 9/18/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

struct ResponseModel: Codable {
    let products: [Product]
}

struct Product: Codable {
    let image: Image
}

struct Image: Codable {
    let id: UInt64
    let src: String
}
