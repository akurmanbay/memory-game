//
//  GameSettingsPage.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/16/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

final class GameSettingsPage: UIViewController, CanDisplayLoader, ConfigurableBackground {

    // MARK: - Properties
    var didTapContinue: (([Product], PlaySettings) -> ())?
    var didTapBackButton: (() -> ())?
    private let viewModel: GameSettingsViewModel
    private let pickerLogic: PickerLogic
    private lazy var currentPickerValues = pickerLogic.getCurrentValues()
    
    private lazy var pickerView: PickerView = {
        let picker = PickerView(pickerLogic: pickerLogic)
        picker.backgroundColor = Constants.purplColor
        picker.layer.masksToBounds = true
        picker.layer.cornerRadius = 4
        return picker
    }()
    
    private let numberOfCardsInSetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = Constants.numberOfCardsInSet
        return label
    }()
    
    private let gridSizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = Constants.gridSize
        return label
    }()
    
    private let backToMainButton: MainActionButton = {
        let button = MainActionButton(title: "Main Page")
        button.addTarget(self, action: #selector(didTapBackToMainPage), for: .touchUpInside)
        return button
    }()
    
    private let startButton: MainActionButton = {
        let button = MainActionButton(title: "Let's go")
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Lifecycle
    init(viewModel: GameSettingsViewModel, pickerLogic: PickerLogic) {
        self.viewModel = viewModel
        self.pickerLogic = pickerLogic
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage(named: Constants.backgroundImageName)
        setupViews()
        updateLabelValues()
        bindToViewModel()
        viewModel.fetchImages()
    }
    
    // MARK: - Private
    private func bindToViewModel() {
        viewModel.didDownloadImages = { [weak self] playSettings in
            guard let products = self?.viewModel.getProducts() else { return }
            self?.didTapContinue?(products, playSettings)
        }
        
        viewModel.showLoader = { [weak self] in
            self?.showLoader()
        }
        
        viewModel.hideLoader = { [weak self] in
            self?.hideLoader()
        }
        
        pickerLogic.didUpdateValues = { [weak self] in
            self?.updateLabelValues()
        }
    }
    
    private func updateLabelValues() {
        currentPickerValues = pickerLogic.getCurrentValues()
        numberOfCardsInSetLabel.text = Constants.numberOfCardsInSet +
            String(currentPickerValues.0)
        gridSizeLabel.text = Constants.gridSize + currentPickerValues.1.string()
    }
    
    private func setupViews() {
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(32)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom).inset(32)
            }
            $0.height.equalTo(150)
        }
        
        stackView.addArrangedSubview(numberOfCardsInSetLabel)
        stackView.addArrangedSubview(gridSizeLabel)
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
        }
        
        view.addSubview(backToMainButton)
        backToMainButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(32)
            $0.right.equalToSuperview().offset(-32)
            $0.bottom.equalToSuperview().offset(-32)
            $0.height.equalTo(48)
        }
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(32)
            $0.right.equalToSuperview().offset(-32)
            $0.bottom.equalTo(backToMainButton.snp.top).offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    @objc private func didTapStartButton() {
        viewModel.prepareCardImages(with: currentPickerValues)
    }
    
    @objc private func didTapBackToMainPage() {
        didTapBackButton?()
    }
}

// MARK: - Constants
extension GameSettingsPage {
    
    enum Constants {
        static let backgroundImageName = "background"
        static let purplColor = UIColor(red: 92 / 255, green: 108 / 255, blue: 190 / 255, alpha: 1)
        static let numberOfCardsInSet = "Number of cards in a set: "
        static let gridSize = "Grid size: "
    }
    
}
