//
//  LoaderView.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/22/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    
    // MARK: - Properties
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func startAnimating() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Private
    private func layoutUI() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
