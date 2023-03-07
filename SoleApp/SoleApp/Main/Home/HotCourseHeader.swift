//
//  HotCourseHeader.swift
//  SoleApp
//
//  Created by SUN on 2023/03/07.
//

import UIKit
import SnapKit

final class HotCourseHeader: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 주변 인기 코스"
        label.font = .pretendardBold(size: 16.0)
        label.textAlignment = .left
        return label
    }()
    
    private let locationStackView = UIStackView()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울 종로구"
        label.font = .pretendardRegular(size: 12.0)
        return label
    }()
    
    private let locationImage: UIImageView = {
        let image = UIImage(named: "my_location")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        locationStackView.distribution = .fill
        locationStackView.spacing = 5.0
        [locationImage,
         locationLabel].forEach({ locationStackView.addArrangedSubview($0) })
        
        [titleLabel,
         locationStackView].forEach({ addSubview($0) })
        
        titleLabel.snp.makeConstraints({
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(locationStackView)
        })
        
        locationStackView.snp.makeConstraints({
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview()
        })
    }
    
}
