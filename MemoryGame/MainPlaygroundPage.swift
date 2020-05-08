//
//  MainPlaygroundPage.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/16/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

final class MainPlaygroundPage: UIViewController, ConfigurableBackground {
    
    // MARK: Properties
    
    var didEndGame: (() -> ())?
    var didTapBack: (() -> ())?
    
    private lazy var playgroundView: PlaygroundPanel = {
        let view = PlaygroundPanel(grid: viewModel.playSettings.1)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.backbutton), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var reloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.reloadButton), for: .normal)
        button.addTarget(self, action: #selector(didTapReloadButton), for: .touchUpInside)
        return button
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
        setBackgroundImage(named: Constants.playgroundBack)
        layoutUI()
        updateMatchesLabel(matched: 0, total: viewModel.getNumberOfPairs())
    }
    
    // MARK: - Private
    private func binding() {
        gameLogic.didNotMatch = { [weak self] indexPaths in
            self?.playgroundView.cardsNotMatch(at: indexPaths)
        }
    
        gameLogic.didChangeNumberOfMatches = { [weak self] numberOfMatches in
            guard let numberOfPairs = self?.viewModel.getNumberOfPairs() else { return }
            if numberOfPairs == numberOfMatches {
                self?.showGameEndAlert()
            }
            self?.updateMatchesLabel(matched: numberOfMatches, total: numberOfPairs)
        }
    }
    
    private func updateMatchesLabel(matched: Int, total: Int) {
        let text = "\(Constants.matches)\(matched)/\(total)"
        playgroundView.updateMatchesLabel(with: text)
    }
    
    private func layoutUI() {
        view.addSubview(playgroundView)
        playgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(12)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom).inset(12)
            }
            $0.left.equalToSuperview().offset(12)
            $0.width.height.equalTo(36)
        }
        
        view.addSubview(reloadButton)
        reloadButton.snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(12)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom).inset(12)
            }
            $0.right.equalToSuperview().offset(-12)
            $0.width.height.equalTo(36)
        }
    }
    
    private func showGameEndAlert() {
        let alertController = UIAlertController(title: "Congratulations!",
                                                message: "You won the game!\nYou've made \(gameLogic.numberOfTries) attempts. Can you do better?",
                                                preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "Exit", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.didEndGame?()
        }
        
        let restartAction = UIAlertAction(title: "Restart", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.reloadData()
        }
        alertController.addAction(exitAction)
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }

    private func showReloadAlert() {
        let alertController = UIAlertController(title: "Are you sure?", message: "You will lose your current progress", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Reload", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func reloadData() {
        viewModel.shuffleProducts()
        gameLogic.reset()
        updateMatchesLabel(matched: 0, total: viewModel.getNumberOfPairs())
        playgroundView.reloadGame()
    }
    
    @objc private func didTapBackButton() {
        didTapBack?()
    }
    
    @objc private func didTapReloadButton() {
        showReloadAlert()
    }
    
}

// MARK: - PlaygroundDataSource
extension MainPlaygroundPage: PlaygroundDataSource {
    
    func itemAtIndex(_ indexPath: IndexPath) -> Product {
        return viewModel.getProduct(at: indexPath)
    }
    
}

// MARK: - PlaygroundDelegate
extension MainPlaygroundPage: PlaygroundDelegate {
    
    func didSelectItem(atIndexPath indexPath: IndexPath) {
        gameLogic.add(item: viewModel.getProduct(at: indexPath),
                      atPosition: indexPath)
    }
    
}

// MARK: - Constants
extension MainPlaygroundPage {
    
    enum Constants {
        static let playgroundBack = "playgroundBack"
        static let matches = "Matches: "
        static let backbutton = "backButton"
        static let reloadButton = "reloadButton"
    }
    
}

