//
//  ViewController.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/16/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController {
    
    var didTapStartAGame: (() -> ())?
    
    private let startAGameButton: MainActionButton = {
        let button = MainActionButton(title: "Start a game")
        button.addTarget(self, action: #selector(didTapStartAGameButton), for: .touchUpInside)
        return button
    }()
    
    private let instructionsButton: MainActionButton = {
        let button = MainActionButton(title: "Instructions")
        return button
    }()
    
    private let scoreboardButton: MainActionButton = {
        let button = MainActionButton(title: "Scoreboard")
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Memory Game"
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func didTapStartAGameButton() {
        didTapStartAGame?()
    }
    
    private func layoutUI() {
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(startAGameButton)
        buttonsStackView.addArrangedSubview(scoreboardButton)
        buttonsStackView.addArrangedSubview(instructionsButton)
        
        buttonsStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(150)
        }
    }
}
