//
//  MyPageViewCell.swift
//  SoleApp
//
//  Created by SUN on 2023/02/28.
//

import UIKit
import SnapKit

final class MyPageTableViewCell: UITableViewCell {
    static let identifier: String = "MyPageViewCell"
    
    private let leftTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardRegular(size: 16.0)
        label.textColor = .black
        return label
    }()
    
    private let rightTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardRegular(size: 16.0)
        label.textColor = .black
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [leftTitleLabel,
         rightTitleLabel].forEach({ addSubview($0) })
        
        leftTitleLabel.snp.makeConstraints({
            $0.left.equalToSuperview().inset(24.0)
            $0.right.equalTo(rightTitleLabel.snp.left)
            $0.verticalEdges.equalToSuperview()
        })
        
        rightTitleLabel.snp.makeConstraints({
            $0.right.equalToSuperview().inset(24.0)
            $0.verticalEdges.equalToSuperview()
        })
    }
    
    func setupCellData(_ data: MyPageCell) {
        leftTitleLabel.text = data.leftTitle
        rightTitleLabel.text = data.rightTitle
    }

}
