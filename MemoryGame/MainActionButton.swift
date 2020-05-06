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
        backgroundColor = UIColor(red: 92 / 255, green: 108 / 255, blue: 190 / 255, alpha: 1)
        setTitle(title, for: .normal)
        setTitleColor(UIColor(red: 244 / 255, green: 224 / 255, blue: 224 / 250, alpha: 1),
                      for: .normal)
        layer.masksToBounds = true
        layer.cornerRadius = 3
        addShadow()
    }
    
    func addShadow() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
        layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
