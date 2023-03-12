//
//  TagListCollectionView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/11.
//

import UIKit

final class TagListCollectionView: UICollectionView {
    private let model =  ["안녕","안녕하세요","안녕하세요 저는 포마입니다.","안녕하세요 만나서 정말 반갑습니다.", "ggggasdgasd", "sadfwefewf"]

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
        configure()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        isScrollEnabled = false
        contentInset = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        register(TagListCollectionViewCell.self, forCellWithReuseIdentifier: "TagListCollectionViewCell")
    }
    
    private func configure() {
        let layout = CollectionViewAutoLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout = layout
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        return model.count
    }
    
    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        guard let cell = dequeueReusableCell(withReuseIdentifier: "TagListCollectionViewCell", for: indexPath) as? TagListCollectionViewCell else { return UICollectionViewCell() }
        cell.label.text = model[indexPath.item]
        return cell
    }
}

