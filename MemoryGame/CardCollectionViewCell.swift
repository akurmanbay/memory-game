//
//  CollectionCell.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/19/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    private var currentImageState: CardSide = .closed
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = Constants.purplColor
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    private let leftGate: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "leftGate")
        return image
    }()
    
    private let rightGate: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "rightGate")
        return image
    }()
    
    private let gatesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(8)
            $0.bottom.right.equalToSuperview().offset(-8)
        }
        
        [leftGate, rightGate].forEach {
            gatesStackView.addArrangedSubview($0)
        }
        
        addSubview(gatesStackView)
        gatesStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageState = .closed
        isUserInteractionEnabled = true
        [leftGate, rightGate].forEach {
            $0.removeFromSuperview()
            gatesStackView.addArrangedSubview($0)
        }
    }
    
    func configure(imageState: CardSide, imageSrc: String?) {
        guard let imageSrc = imageSrc,
            let imageData = ImageCache.shared.storage.value(forKey: imageSrc)
        else { return }
        imageView.image = UIImage(data: imageData)
        currentImageState = imageState
        gatesStackView.alpha = imageState == .open ? 0 : 1
    }
    
    func didTapCell() {
        if currentImageState == .open {
            gatesStackView.toggleAlpha()
        } else {
            isUserInteractionEnabled = false
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .transitionCurlUp,
                       animations: {
            let multiplier: CGFloat = self.currentImageState == .open ? -1 : 1
            self.rightGate.frame.origin.x += multiplier * self.imageView.frame.width / 2
            self.leftGate.frame.origin.x -= multiplier * self.imageView.frame.width / 2
        }, completion: { _ in
            if self.currentImageState == .closed {
                self.gatesStackView.toggleAlpha()
            } else {
                self.isUserInteractionEnabled = true
            }
            self.currentImageState.toggle()
        })
    }
}


// MARK: - Constants
extension CardCollectionViewCell {
    
    enum Constants {
        static let purplColor = UIColor(red: 92 / 255, green: 108 / 255, blue: 190 / 255, alpha: 1)
    }
    
}
