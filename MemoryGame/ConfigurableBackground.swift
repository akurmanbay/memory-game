//
//  ConfigurableBackground.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 5/6/20.
//  Copyright © 2020 Ayan Kurmanbay. All rights reserved.
//

import UIKit

protocol ConfigurableBackground {
    func setBackgroundImage(named: String)
}

extension ConfigurableBackground where Self: UIViewController {
    func setBackgroundImage(named name: String) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: name)
        imageView.alpha = 0.5
        view.clipsToBounds = true
        view.addSubview(imageView)
        view.backgroundColor = .black
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
