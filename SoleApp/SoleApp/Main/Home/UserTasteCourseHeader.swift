//
//  UserTasteCourseHeader.swift
//  SoleApp
//
//  Created by SUN on 2023/03/07.
//

import UIKit
import SnapKit

final class UserTasteCourseHeader: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 취향 코스"
        label.font = .pretendardBold(size: 16.0)
        label.textAlignment = .left
        return label
    }()
    
    private let setTasteButton: UIButton = {
        let button = UIButton()
        button.setTitle("취향 설정하기", for: .normal)
        button.titleLabel?.font = .pretendardRegular(size: 12.0)
        button.setTitleColor(.gray_404040, for: .normal)
        button.setImage(UIImage(named: "chevron-right"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [titleLabel,
        setTasteButton].forEach({ addSubview($0) })
        
        titleLabel.snp.makeConstraints({
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(setTasteButton)
        })
        
        setTasteButton.snp.makeConstraints({
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview()
        })
    }
}
