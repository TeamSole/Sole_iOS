//
//  CourseSummarySectionView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/11.
//

import UIKit
import SnapKit

final class CourseSummarySectionView: UIView {
    private let model =  ["안녕","안녕하세요","안녕하세요 저는 포마입니다.","안녕하세요 만나서 정말 반갑습니다.", "ggggasdgasd", "sadfwefewf"]
        

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "코스이름"
        label.textAlignment = .left
        label.font = .pretendardBold(size: 16.0)
        label.textColor = .black
        return label
    }()
    
    private let loveImageView: UIImageView = {
        let image = UIImage(named: "blackLove")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private let loveNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "123"
        label.textColor = .gray_404040
        label.font = .pretendardRegular(size: 11.0)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .pretendardRegular(size: 13.0)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let registerDateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().toString()
        label.textColor = .gray_404040
        label.font = .pretendardRegular(size: 12.0)
        label.textAlignment = .left
        return label
    }()
    
    private let locationInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "지역 시간 소요 km이동"
        label.textColor = .gray_404040
        label.font = .pretendardRegular(size: 12.0)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionViewAutoLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 32.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        collectionView.register(TagListCollectionViewCell.self, forCellWithReuseIdentifier: "TagListCollectionViewCell")
        collectionView.dataSource = self
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        [titleLabel,
        loveImageView,
        loveNumberLabel,
        descriptionLabel,
        registerDateLabel,
        locationInfoLabel,
         collectionView].forEach({ addSubview($0) })
        
        titleLabel.snp.makeConstraints({
            $0.top.leading.equalToSuperview()
            $0.trailing.equalTo(loveImageView.snp.leading)
        })
        titleLabel.setContentHuggingPriority(.init(250), for: .horizontal)
        
        loveImageView.snp.makeConstraints({
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalTo(loveNumberLabel.snp.leading)
        })
        
        loveNumberLabel.snp.makeConstraints({
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel.snp.centerY)
        })
        
        descriptionLabel.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalToSuperview()
        })
        
        registerDateLabel.snp.makeConstraints({
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalToSuperview()
        })
        
        locationInfoLabel.snp.makeConstraints({
            $0.top.equalTo(registerDateLabel.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalToSuperview()
        })
        
        collectionView.snp.makeConstraints({
            $0.top.equalTo(locationInfoLabel.snp.bottom).offset(8.0)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(400)
        })
    }
}

extension CourseSummarySectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagListCollectionViewCell", for: indexPath) as? TagListCollectionViewCell else { return UICollectionViewCell() }
        cell.label.text = model[indexPath.item]
        return cell
    }
    
    
}
