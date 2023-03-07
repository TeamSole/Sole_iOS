//
//  HotCourseCell.swift
//  SoleApp
//
//  Created by SUN on 2023/03/05.
//

import UIKit
import SnapKit

final class HotCourseCell: UICollectionViewCell {
    static let identifier: String = "HotCourseCell"
    
    private let imageView: UIImageView = UIImageView()
    
    private let courseTitle: UILabel = {
        let label = UILabel()
        label.font = .pretendardMedium(size: 15.0)
        label.text = "따듯한 3월에 가기 좋은 삼청동"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private let courseTypeTitle: UILabel = {
        let label = UILabel()
        label.font = .pretendardMedium(size: 15.0)
        label.text = "전시코스"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    override func layoutSubviews() {
        [imageView,
        courseTitle,
         courseTypeTitle].forEach({ addSubview($0) })
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        imageView.backgroundColor = .black
        imageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        courseTypeTitle.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(16.0)
        })
        
        courseTitle.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(courseTypeTitle.snp.top).offset(6.0)
        })
    }
}
