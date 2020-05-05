//
//  JsonParser.swift
//  NSURLSession+Codable
//
//  Created by Ayan Kurmanbay on 9/18/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

enum Result<T: Codable> {
    case success(T)
    case failure(Error)
}

final class ResponseDataModel<T: Codable> {
    
    let result: Result<T>
    let httpResponse: HTTPURLResponse?
    let data: Data?
    
    init(_ result: Result<T>, _ httpResponse: HTTPURLResponse? = nil, _ data: Data? = nil) {
        self.result = result
        self.httpResponse = httpResponse
        self.data = data
    }
}

class ResponseParser {
    func parse<T: Codable>(data: Data, type: T.Type, completion: @escaping ((ResponseDataModel<T>) -> Void)) {
        do {
            let decoder = JSONDecoder()
            let res = try decoder.decode(type, from: data)
            completion(ResponseDataModel(.success(res)))
        } catch {
            completion(ResponseDataModel(.failure(error)))
        }
    }
}

