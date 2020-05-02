//
//  MainActionButton.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/23/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

class MainActionButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 84 / 255, green: 160 / 255, blue: 1, alpha: 1)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.masksToBounds = true
        layer.cornerRadius = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
