//
//  CourseDetailTableViewCell.swift
//  SoleApp
//
//  Created by SUN on 2023/03/12.
//

import UIKit
import SnapKit

final class CourseDetailTableViewCell: UITableViewCell {
    private let indexNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .pretendardBold(size: 12.0)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .blue_4708FA
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        return label
    }()
    
    private let courseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "장소명"
        label.font = .pretendardMedium(size: 15.0)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let detailView = UIView()
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울 송파구 올림픽로 269 잠실롯데캐슬 2층"
        label.textColor = .gray_383838
        label.textAlignment = .left
        label.font = .pretendardRegular(size: 12.0)
        return label
    }()
    
    private let detailInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle("상세정보", for: .normal)
        button.setImage(UIImage(named: "info"), for: .normal)
        button.setTitleColor(.blue_4708FA, for: .normal)
        return button
    }()
    
    private let view = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [indexNumberLabel,
         courseTitleLabel,
        detailView].forEach({ addSubview($0) })
        
        indexNumberLabel.snp.makeConstraints({
            $0.width.height.equalTo(20.0)
            $0.leading.top.equalToSuperview()
        })
        
        courseTitleLabel.snp.makeConstraints({
            $0.leading.equalTo(indexNumberLabel.snp.trailing).offset(16.0)
            $0.centerY.equalTo(indexNumberLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        })
        
        detailView.snp.makeConstraints({
            $0.leading.equalTo(courseTitleLabel.snp.leading)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            
        })
        
        [locationLabel,
        detailInfoButton,
         view].forEach({detailView.addSubview($0)})
        
        locationLabel.snp.makeConstraints({
            $0.leading.top.trailing.equalToSuperview()
        })
        
        detailInfoButton.snp.makeConstraints({
            $0.top.equalTo(locationLabel.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalToSuperview()
        })
        
        view.snp.makeConstraints({
            $0.width.height.equalTo(200)
            $0.top.equalTo(detailInfoButton.snp.bottom).offset(8.0)
            $0.bottom.equalToSuperview()
        })
    }
}
