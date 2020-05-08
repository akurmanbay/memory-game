//
//  AppPagesFactory.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/16/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import Foundation

// TODO: Add DI library
class AppPagesFactory {

    // MARK: Pages
    func createMainStarterPage() -> MenuViewController {
        return MenuViewController()
    }
    
    func createSettingsPage() -> GameSettingsPage {
        return GameSettingsPage(viewModel: createGameSettingsViewModel(),
                                pickerLogic: createPickerLogic())
    }
    
    func createMainPlaygroundPage(products: [Product],
                                  playSettings: PlaySettings) -> MainPlaygroundPage {
        return MainPlaygroundPage(viewModel: createMainPlaygroundViewModel(prodcuts: products,
                                                                           playSettings: playSettings),
                                  gameLogic: createGameLogic(playSettings.0))
    }
    
    func createInstructionsPage() -> InstructionsViewController {
        return InstructionsViewController()
    }
    
    //MARK: ViewModels
    private func createGameSettingsViewModel() -> GameSettingsViewModel {
        return GameSettingsViewModel(downloaderService: createDownloaderService())
    }
    
    private func createMainPlaygroundViewModel(prodcuts: [Product],
                                               playSettings: PlaySettings) -> MainPlaygroundViewModel {
        return MainPlaygroundViewModel(products: prodcuts, playSettings: playSettings)
    }
    
    private func createGameLogic(_ elements: Int) -> GameLogic {
        return GameLogic(numberOfDuplicates: elements)
    }
    
    private func createPickerLogic() -> PickerLogic {
        return PickerLogicImpl()
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
