//
//  PlaygroundPanel.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 9/16/19.
//  Copyright © 2019 Ayan Kurmanbay. All rights reserved.
//

import UIKit

protocol PlaygroundDataSource: class {
    func itemAtIndex(_ index: IndexPath) -> Product
}

protocol PlaygroundDelegate: class {
    func didSelectItem(atIndexPath indexPath: IndexPath)
}

enum CardSide {
    case open, closed
    
    mutating func toggle() {
        self = self == .closed ? .open : .closed
    }
}

final class PlaygroundPanel: UIView {
 
    weak var dataSource: PlaygroundDataSource?
    weak var delegate: PlaygroundDelegate?
    
    private let numberOfRows: CGFloat
    private var imageStates: [CardSide]
    
    private lazy var customizedCellSize: CGFloat = (UIScreen.main.bounds.width - numberOfRows + 1) / numberOfRows
    private lazy var collectionViewHeight: CGFloat = customizedCellSize * numberOfRows + numberOfRows - 1
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: customizedCellSize, height: customizedCellSize)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(numberOfRows: Int) {
        self.numberOfRows = CGFloat(numberOfRows)
        imageStates = Array(repeating: .closed, count: numberOfRows * numberOfRows)
        super.init(frame: .zero)
        backgroundColor = .white
        setupViews()
    }
    
    func didFoundNotMatch(at indexPaths: [IndexPath]) {
        indexPaths.forEach {
            self.imageStates[$0.row].toggle()
            if let cell = self.collectionView.cellForItem(at: $0) as? CollectionCell {
                cell.didTapCell()
            }
        }
        self.collectionView.reloadItems(at: indexPaths)
    }
    
    private func setupViews() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(collectionViewHeight)
        }
        
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlaygroundPanel: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(numberOfRows * numberOfRows)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                            for: indexPath) as? CollectionCell
        else {
            return UICollectionViewCell()
        }
        let product = dataSource?.itemAtIndex(indexPath)
        cell.configure(imageState: imageStates[indexPath.row],
                       imageSrc: product?.image.src)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell else { return }
        if imageStates[indexPath.row] == .closed {
            cell.didTapCell()
            imageStates[indexPath.row].toggle()
            delegate?.didSelectItem(atIndexPath: indexPath)
        }
    }
}
