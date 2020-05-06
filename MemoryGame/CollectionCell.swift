//
//  CollectionCell.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/19/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    var canReloadCell: (() -> ())?
    var didEndAnimating: (() -> ())?
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 4
        return image
    }()
    
    private let coverImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 4
        image.backgroundColor = UIColor(red: 92 / 255, green: 108 / 255, blue: 190 / 255, alpha: 1)
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(4)
            $0.bottom.right.equalToSuperview().offset(-4)
        }
        
        addSubview(coverImageView)
        coverImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(imageState: CardSide, imageSrc: String?) {
        guard let imageSrc = imageSrc,
            let imageData = ImageCache.shared.storage.value(forKey: imageSrc)
        else { return }
        imageView.image = UIImage(data: imageData)
        coverImageView.alpha = imageState == .open ? 0 : 1
    }
    
    func didTapCell() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .transitionCurlUp,
                       animations: {
            self.coverImageView.toggleAlpha()
        }, completion: nil)
    }
}
