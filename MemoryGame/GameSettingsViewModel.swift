//
//  GameSettingsViewModel.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/22/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

typealias PlaySettings = (Int, Grid)

class GameSettingsViewModel {
    
    // MARK: - Properties
    var didDownloadImages: ((PlaySettings) -> ())?
    var showLoader: (() -> ())?
    var hideLoader: (() -> ())?
    
    private let downloaderService: DownloaderService
    private var products: [Product] = []
    private var shuffledProducts: [Product] = []

    // MARK: - Lifecycle
    init(downloaderService: DownloaderService) {
        self.downloaderService = downloaderService
    }
    
    // MARK: - Public
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
        },
        failure: { [weak self] error in
            self?.hideLoader?()
            debugPrint(error)
        })
    }
    
    func prepareCardImages(with value: PlaySettings) {
        let numberOfUniqueElements = value.1.size() / value.0
        var loadedImageCounter = 0
        shuffledProducts = Array(products.shuffled()[..<numberOfUniqueElements])
        showLoader?()
        for product in shuffledProducts {
            downloadImage(product) { [weak self] in
                loadedImageCounter += 1
                if loadedImageCounter == numberOfUniqueElements {
                    DispatchQueue.main.async {
                        self?.hideLoader?()
                        self?.didEndImageDownloading(with: value)
                    }
                }
            }
        }
    }
    
    // MARK: - Private
    private func didEndImageDownloading(with value: PlaySettings) {
        var shuffledProductsCurrent = [Product]()
        for _ in 0..<value.0 {
            shuffledProductsCurrent += shuffledProducts
        }
        shuffledProducts = shuffledProductsCurrent.shuffled()
        didDownloadImages?(value)
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
