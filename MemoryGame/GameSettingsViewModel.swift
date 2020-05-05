//
//  GameSettingsViewModel.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/22/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

class GameSettingsViewModel {
    
    var didDownloadImages: (() -> ())?
    var showLoader: (() -> ())?
    var hideLoader: (() -> ())?
    
    private let downloaderService: DownloaderService
    private var products: [Product] = []
    private var shuffledProducts: [Product] = []

    init(downloaderService: DownloaderService) {
        self.downloaderService = downloaderService
    }
    
    func getProducts() -> [Product] {
        return shuffledProducts
    }
    
    func fetchImages() {
        showLoader?()
        downloaderService.getImages(success: { [weak self] products in
            self?.products = products
            DispatchQueue.main.async {
                self?.hideLoader?()
            }
        }, failure: { error in
            debugPrint(error)
        })
    }
    
    func startImageDownloading(_ numberOfElements: Int) {
        shuffledProducts = Array(products.shuffled()[..<numberOfElements])
        var downloadedImageCounter: Int = 0
        self.showLoader?()
        for product in shuffledProducts {
            downloadImage(product) { [weak self] in
                downloadedImageCounter += 1
                if downloadedImageCounter == numberOfElements {
                    self?.didEndImageDownloading()
                    DispatchQueue.main.async {
                        self?.hideLoader?()
                        self?.didDownloadImages?()
                    }
                }
            }
        }
    }
    
    private func didEndImageDownloading() {
        shuffledProducts += shuffledProducts
        shuffledProducts = shuffledProducts.shuffled()
    }
    
    private func downloadImage(_ product: Product, didFetch: @escaping () -> ()) {
        downloaderService.fetchImage(fromUrl: product.image.src, success: { imageData in
            ImageCache.shared.storage.insert(imageData, forKey: product.image.src)
            didFetch()
        }, failure: { error in
            debugPrint(error)
        })
    }
}
