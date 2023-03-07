//
//  UserTasteCourseCell.swift
//  SoleApp
//
//  Created by SUN on 2023/03/08.
//

import UIKit
import SnapKit

final class UserTasteCourseCell: UICollectionViewCell {
    static let identifier: String = "UserTasteCourseCell"
    
    private let imageView: UIImageView = UIImageView()
    
    private let courseTitle: UILabel = {
        let label = UILabel()
        label.font = .pretendardBold(size: 16)
        label.text = "그라운드시소 전시 데이트"
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "love"), for: .normal)
        button.setImage(UIImage(named: "love_selected"), for: .selected)
        return button
    }()
    
    private let locationInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardRegular(size: 12.0)
        label.textColor = .gray_404040
        label.text = "서울 종로구 ∙ 5시간 소요 ∙ 2.2km 이동"
        label.textAlignment = .left
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray_EDEDED.cgColor
        [imageView,
         courseTitle,
        likeButton,
         locationInfoLabel].forEach({ addSubview($0) })
        
        
        imageView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(courseTitle.snp.top).offset(16.0)
        })
        courseTitle.snp.makeConstraints({
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.equalTo(likeButton.snp.leading)
        })
        
        likeButton.snp.makeConstraints({
            $0.centerY.equalTo(courseTitle.snp.centerY)
            $0.trailing.equalToSuperview().inset(16.0)
        })
        
        locationInfoLabel.snp.makeConstraints({
            $0.top.equalTo(courseTitle.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(16.0)
        })
        
       
        
        
       
        
        
    }
}

