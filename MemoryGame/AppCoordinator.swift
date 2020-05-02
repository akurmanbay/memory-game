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
        
        starterPage.didTapStartAGame = { [weak self] in
            self?.showGameSettingsPage()
        }
        
        navigationController = UINavigationController(rootViewController: starterPage)
    }
    
    private func showGameSettingsPage() {
        let gameSettingsPage = pagesFactory.createSettingsPage()
        
        gameSettingsPage.didTapContinue = { [weak self] products in
            self?.showMainPlaygroundPage(products: products)
        }
        
        navigationController.pushViewController(gameSettingsPage, animated: true)
    }
    
    private func showMainPlaygroundPage(products: [Product]) {
        let mainPlaygroundPage = pagesFactory.createMainPlaygroundPage(products: products)
        
        mainPlaygroundPage.didEndGame = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }
        
        navigationController.pushViewController(mainPlaygroundPage, animated: true)
    }
}
