//
//  MainPlaygroundPage.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/16/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

final class MainPlaygroundPage: UIViewController {
    
    // MARK: Properties
    
    var didEndGame: (() -> ())?
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(UIColor(red: 84 / 255, green: 160 / 255, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var playgroundView: PlaygroundPanel = {
        let view = PlaygroundPanel(numberOfRows: viewModel.getGridSize())
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private let viewModel: MainPlaygroundViewModel
    private let gameLogic: GameLogic
    
    
    // MARK: - Lifecycle
    init(viewModel: MainPlaygroundViewModel, gameLogic: GameLogic) {
        self.viewModel = viewModel
        self.gameLogic = gameLogic
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        layoutUI()
    }
    
    
    // MARK: - Private
    private func binding() {
        gameLogic.didNotMatch = { [weak self] indexPaths in
            self?.playgroundView.didFoundNotMatch(at: indexPaths)
        }
    
        gameLogic.didChangeNumberOfMatches = { [weak self] numberOfMatches in
            guard let numberOfPairs = self?.viewModel.getNumberOfPairs() else { return }
            if numberOfPairs == numberOfMatches {
                self?.showAlertController()
            }
        }
    }
    
    private func layoutUI() {
        view.addSubview(playgroundView)
        playgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
    }
    
    private func showAlertController() {
        let alertController = UIAlertController(title: "Congratulations", message: "You win the game!", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.didEndGame?()
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true, completion: nil)
    }

    private func showExitConfirmationAlert() {
        let alertController = UIAlertController(title: "Exit", message: "Are you sure you want to quit the game?", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.didEndGame?()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func didTapExitButton() {
        showExitConfirmationAlert()
    }
    
}

// MARK: - PlaygroundDataSource
extension MainPlaygroundPage: PlaygroundDataSource {
    
    func itemAtIndex(_ indexPath: IndexPath) -> Product {
        return viewModel.products[indexPath.row]
    }
    
}

// MARK: - PlaygroundDelegate
extension MainPlaygroundPage: PlaygroundDelegate {
    
    func didSelectItem(atIndexPath indexPath: IndexPath) {
        gameLogic.add(item: viewModel.getProduct(at: indexPath),
                      atPosition: indexPath)
    }
    
}
