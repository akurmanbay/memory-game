//
//  CollectionCell.swift
//  NSURLSession+Codable
//
//  Created by Ayan Kurmanbay on 9/19/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    var canReloadCell: (() -> ())?
    var didEndAnimating: (() -> ())?
    private var imageState: ImageState = .front
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 4
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.image = nil
        backgroundColor = .white
        
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageState: ImageState, image: UIImage?) {
        self.imageState = imageState
        setImageIfNeeded(image)
        canReloadCell = { [weak self] in
            self?.setImageIfNeeded(image)
        }
    }
    
    private func setImageIfNeeded(_ image: UIImage?) {
        if imageState == .back {
            self.imageView.image = image
        } else {
            self.imageView.image = UIImage(color: UIColor(red: 16 / 255, green: 172 / 255, blue: 132 / 255, alpha: 1))
        }
    }
    
    func didTapCell() {
        magnify()
    }
}

// MARK: - Animation
extension CollectionCell {
    private func magnify() {
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.isUserInteractionEnabled = false
            self.imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { [unowned self] _ in
            self.flip()
        })
    }
    
    private func flip() {
        UIView.transition(with: imageView, duration: 0.25, options: [.transitionFlipFromBottom], animations: { [unowned self] in
            self.imageState.toggle()
            self.imageView.image = nil
        }, completion: { [unowned self] _ in
            self.diminish()
        })
    }
    
    private func diminish() {
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.imageView.transform = .identity
            self.canReloadCell?()
        }, completion: { [unowned self] _ in
            self.didEndAnimating?()
            self.isUserInteractionEnabled = true
        })
    }
}
