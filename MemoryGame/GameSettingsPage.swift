//
//  GameSettingsPage.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/16/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

final class GameSettingsPage: UIViewController, CanDisplayLoader {
    
    var didTapContinue: (([Product]) -> ())?
    
    private let viewModel: GameSettingsViewModel
    
    private let easyModeButton: MainActionButton = {
        let button = MainActionButton(title: "Easy Mode (4x4)")
        button.addTarget(self, action: #selector(didTapEasyMode), for: .touchUpInside)
        return button
    }()
    
    private let hardModeButton: MainActionButton = {
        let button = MainActionButton(title: "Hard Mode (6x6)")
        button.addTarget(self, action: #selector(didTapHardMode), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    init(viewModel: GameSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Game Settings"
        
        bindToViewModel()
        setupViews()
        viewModel.fetchImages()
    }
    
    private func bindToViewModel() {
        viewModel.didDownloadImages = { [weak self] in
            guard let products = self?.viewModel.getProducts() else { return }
            self?.didTapContinue?(products)
        }
        
        viewModel.showLoader = { [weak self] in
            self?.showLoader()
        }
        
        viewModel.hideLoader = { [weak self] in
            self?.hideLoader()
        }
    }
    
    private func setupViews() {
        stackView.addArrangedSubview(easyModeButton)
        stackView.addArrangedSubview(hardModeButton)
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(150)
        }
    }
    
    @objc private func didTapEasyMode() {
        viewModel.startImageDownloading(8)
    }
    
    @objc private func didTapHardMode() {
        viewModel.startImageDownloading(18)
    }
}
