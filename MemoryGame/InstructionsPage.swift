//
//  InstructionsPage.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 5/8/20.
//  Copyright © 2020 Ayan Kurmanbay. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController, ConfigurableBackground {
    
    // MARK: - Properties
    private let gameInstructionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let backToMainButton: MainActionButton = {
        let button = MainActionButton(title: "Main Page")
        button.addTarget(self, action: #selector(didTapBackToMainPage), for: .touchUpInside)
        return button
    }()
    
    private let instructions = [
        "Turn over any two to five cards. (depends on the choice that you made)",
        "If selected cards match, they will stay.",
        "If they don't match they will close back.",
        "Remember what was on each card and where it was.",
        "The game is over when all the cards have been matched."
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage(named: Constants.backgroundImageName)
        
        view.addSubview(gameInstructionsLabel)
        gameInstructionsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(backToMainButton)
        backToMainButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(32)
            $0.right.equalToSuperview().offset(-32)
            $0.bottom.equalToSuperview().offset(-32)
            $0.height.equalTo(48)
        }
        
        var fullInstruction = ""
        for instruction in instructions {
            fullInstruction += "\(instruction)\n\n"
        }
        gameInstructionsLabel.text = fullInstruction
    }
    
    @objc private func didTapBackToMainPage() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Constants
extension InstructionsViewController {
    
    enum Constants {
        static let backgroundImageName = "background"
    }
    
}
