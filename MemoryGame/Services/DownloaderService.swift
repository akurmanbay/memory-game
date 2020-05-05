//
//  DownloaderService.swift
//  NSURLSession+Codable
//
//  Created by Ayan Kurmanbay on 9/18/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

protocol DownloaderService {
    func getImages(success: @escaping ([Product]) -> (), failure: @escaping (Error) -> ())
    func fetchImage(fromUrl urlString: String, success: @escaping (Data) -> (), failure: @escaping (Error) -> ())
}

class DownloaderServiceImpl: DownloaderService {
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getImages(success: @escaping ([Product]) -> (), failure: @escaping (Error) -> ()) {
        let urlString = "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let url = URL(string: urlString) else { return }
        networkClient.makeRequest(url: url) { (responseData: ResponseDataModel<ResponseModel>) in
            switch responseData.result {
            case .success(let value):
                success(value.products)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func fetchImage(fromUrl urlString: String, success: @escaping (Data) -> (), failure: @escaping (Error) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        networkClient.getImage(url: url, success: { imageData in
            success(imageData)
        }, failure: { error in
            failure(error)
        })
    }
}
