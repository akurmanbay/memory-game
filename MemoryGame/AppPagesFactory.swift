//
//  AppPagesFactory.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/16/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

class AppPagesFactory {

    // MARK: Pages
    func createMainStarterPage() -> MenuViewController {
        return MenuViewController()
    }
    
    func createSettingsPage() -> GameSettingsPage {
        return GameSettingsPage(viewModel: createGameSettingsViewModel())
    }
    
    func createMainPlaygroundPage(products: [Product]) -> MainPlaygroundPage {
        return MainPlaygroundPage(viewModel: createMainPlaygroundViewModel(prodcuts: products),
                                  gameLogic: createGameLogic())
    }
    
    //MARK: ViewModels
    private func createGameSettingsViewModel() -> GameSettingsViewModel {
        return GameSettingsViewModel(downloaderService: createDownloaderService())
    }
    
    private func createMainPlaygroundViewModel(prodcuts: [Product]) -> MainPlaygroundViewModel {
        return MainPlaygroundViewModel(products: prodcuts)
    }
    
    private func createGameLogic() -> GameLogic {
        return GameLogic(numberOfDuplicates: 2)
    }
    
    //MARK: Services (should be separated to another class)
    private func createDownloaderService() -> DownloaderService {
        return DownloaderServiceImpl(networkClient: createNetworkClient())
    }
    
    private func createNetworkClient() -> NetworkClient {
        return NetworkClientImpl(responseParser: crateResponseParser())
    }
    
    private func crateResponseParser() -> ResponseParser {
        return ResponseParser()
    }
}
