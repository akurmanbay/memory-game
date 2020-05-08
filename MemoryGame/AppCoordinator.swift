//
//  AppCoordinator.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/16/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    private let pagesFactory: AppPagesFactory
    private(set) var navigationController: UINavigationController!
    
    init(pagesFactory: AppPagesFactory) {
        self.pagesFactory = pagesFactory
    }
    
    func start() {
        let starterPage = pagesFactory.createMainStarterPage()
        
        starterPage.didStartGame = { [weak self] in
            self?.showGameSettingsPage()
        }
        
        starterPage.didTapInstructions = { [weak self] in
            self?.showInstructionsPage()
        }
        
        navigationController = UINavigationController(rootViewController: starterPage)
    }
    
    private func showGameSettingsPage() {
        let gameSettingsPage = pagesFactory.createSettingsPage()
        
        gameSettingsPage.didTapContinue = { [weak self] products, playSettings in
            self?.showMainPlaygroundPage(products: products, playSettings: playSettings)
        }
        
        gameSettingsPage.didTapBackButton = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(gameSettingsPage, animated: true)
    }
    
    private func showMainPlaygroundPage(products: [Product], playSettings: PlaySettings) {
        let mainPlaygroundPage = pagesFactory.createMainPlaygroundPage(products: products,
                                                                       playSettings: playSettings)
        
        mainPlaygroundPage.didEndGame = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }
        
        mainPlaygroundPage.didTapBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(mainPlaygroundPage, animated: true)
    }
    
    private func showInstructionsPage() {
        let instrPage = pagesFactory.createInstructionsPage()
    
        navigationController.present(instrPage, animated: true, completion: nil)
    }
}
