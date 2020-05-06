//
//  ViewController.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/16/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController, ConfigurableBackground {
    
    // MARK: - Properties
    var didTapStartAGame: (() -> ())?
    
    private let gameTitle: UILabel = {
        let label = UILabel()
        label.textColor = Constants.gameTitleColor
        label.text = Constants.gameTitle
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 64)
        label.numberOfLines = 0
        return label
    }()
    
    private let startAGameButton: MainActionButton = {
        let button = MainActionButton(title: Constants.start)
        button.addTarget(self, action: #selector(didTapStartAGameButton), for: .touchUpInside)
        return button
    }()
    
    private let instructionsButton: MainActionButton = {
        let button = MainActionButton(title: Constants.instructions)
        return button
    }()
    
    private let scoreboardButton: MainActionButton = {
        let button = MainActionButton(title: Constants.scoreboard)
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setBackgroundImage(named: Constants.backgroundImageName)
        layoutUI()
    }
    
    // MARK: - Private
    
    private func layoutUI() {
        
        view.addSubview(gameTitle)
        gameTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(buttonsStackView)
        [startAGameButton, scoreboardButton, instructionsButton].forEach {
            buttonsStackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(48)
            }
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-64)
            $0.left.equalToSuperview().offset(48)
            $0.right.equalToSuperview().offset(-48)
        }
    }
    
    @objc private func didTapStartAGameButton() {
        didTapStartAGame?()
    }
}

// MARK: - Constants
extension MenuViewController {
    
    enum Constants {
        static let backgroundImageName = "background"
        static let start = "Start"
        static let instructions = "Instructions"
        static let scoreboard = "Scoreboard"
        
        static let gameTitle = "Memory Game"
        static let gameTitleColor = UIColor(red: 244 / 255, green: 224 / 255, blue: 224 / 250, alpha: 1)
    }
    
}
