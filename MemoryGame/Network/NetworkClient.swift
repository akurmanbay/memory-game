//
//  NetworkClient.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/18/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

protocol NetworkClient {
    func makeRequest<T: Codable> (url: URL, completion: @escaping (ResponseDataModel<T>) -> ())
    func getImage(url: URL, success: @escaping (Data) -> (), failure: @escaping (Error) -> ())
}

class NetworkClientImpl: NetworkClient {
    
    private let responseParser: ResponseParser
    
    init(responseParser: ResponseParser) {
        self.responseParser = responseParser
    }
    
    func makeRequest<T: Codable> (url: URL, completion: @escaping (ResponseDataModel<T>) -> ()) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else { return }
            self.responseParser.parse(data: data, type: T.self, completion: { responseDataModel in
                completion(responseDataModel)
            })
        })
        task.resume()
    }
    
    func getImage(url: URL, success: @escaping (Data) -> (), failure: @escaping (Error) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                failure(error)
            }
            guard let data = data else { return }
            success(data)
        }
        task.resume()
    }
}
