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

final class PlaygroundPanel: UIView {

    // MARK: - Properties
    weak var dataSource: PlaygroundDataSource?
    weak var delegate: PlaygroundDelegate?
    
    private var imageStates: [CardSide]
    private let grid: Grid
    
    private lazy var cellWidth: CGFloat = {
        let screenWidth = UIScreen.main.bounds.width
        let collectionViewWidth = screenWidth - 2 * Constants.collectionSideOffset
        return (collectionViewWidth - Constants.interItemSpacing * (grid.cols - 1)) / grid.cols
    }()
    
    private lazy var cellHeight: CGFloat = {
        return cellWidth * Constants.cellHeightMul
    }()
    
    private lazy var collectionViewHeight: CGFloat = {
        return cellHeight * grid.rows + Constants.interItemSpacing * (grid.rows - 1)
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = Constants.interItemSpacing
        layout.minimumLineSpacing = Constants.interItemSpacing
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let matchesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    // MARK: - Lifecycle
    init(grid: Grid) {
        self.grid = grid
        imageStates = Array(repeating: .closed, count: grid.size())
        super.init(frame: .zero)
        backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func cardsNotMatch(at indexPaths: [IndexPath]) {
        indexPaths.forEach {
            self.imageStates[$0.row].toggle()
            if let cell = self.collectionView.cellForItem(at: $0) as? CardCollectionViewCell {
                cell.didTapCell()
            }
        }
    }
    
    func updateMatchesLabel(with text: String) {
        matchesLabel.text = text
    }
    
    func reloadGame() {
        for index in 0..<imageStates.count {
            imageStates[index] = .closed
        }
        collectionView.reloadData()
    }
    
    // MARK: - Private
    private func setupViews() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Constants.collectionSideOffset)
            $0.right.equalToSuperview().offset(-Constants.collectionSideOffset)
            $0.centerY.equalToSuperview().offset(20)
            $0.height.equalTo(collectionViewHeight)
        }
        
        addSubview(matchesLabel)
        matchesLabel.snp.makeConstraints {
            $0.left.equalTo(collectionView.snp.left)
            $0.bottom.equalTo(collectionView.snp.top).offset(-10)
        }
        
        collectionView.register(CardCollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: CardCollectionViewCell.self))
    }
    
}

// MARK: - UICollectionViewDataSource
extension PlaygroundPanel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageStates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:String(describing: CardCollectionViewCell.self),
            for: indexPath) as? CardCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let product = dataSource?.itemAtIndex(indexPath)
        cell.configure(imageState: imageStates[indexPath.row],
                       imageSrc: product?.image.src)
        
        return cell
    }

}

// MARK: - UICollectionViewDelegate
extension PlaygroundPanel: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        if imageStates[indexPath.row] == .closed {
            cell.didTapCell()
            imageStates[indexPath.row].toggle()
            delegate?.didSelectItem(atIndexPath: indexPath)
        }
    }
    
}

// MARK: - Constants
extension PlaygroundPanel {
    
    enum Constants {
        static let collectionSideOffset: CGFloat = 8
        static let cellHeightMul: CGFloat = 0.8
        static let interItemSpacing: CGFloat = 2
    }
    
}
