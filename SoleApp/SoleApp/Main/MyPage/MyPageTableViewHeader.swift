//
//  MyPageTableViewHeader.swift
//  SoleApp
//
//  Created by SUN on 2023/02/28.
//

import UIKit
import SnapKit

final class MyPageTableViewHeader: UITableViewHeaderFooterView {
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "profile56")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "라면"
        label.font = .pretendardMedium(size: 16.0)
        label.textColor = .black
        return label
    }()
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.text = "라면"
        label.font = .pretendardRegular(size: 12.0)
        label.textColor = .black
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "라면"
        label.font = .pretendardRegular(size: 12.0)
        label.textColor = .black
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_EDEDED
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [profileImage,
         nicknameLabel,
         followingLabel,
         separator,
         followerLabel,
         bottomSeparator].forEach({ addSubview($0) })
        
        profileImage.snp.makeConstraints({
            $0.leading.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(56.0)
        })

        nicknameLabel.snp.makeConstraints({
            $0.leading.equalTo(profileImage.snp.trailing).offset(16.0)
            $0.bottom.equalTo(profileImage.snp.centerY).offset(2.0)
        })
        
        followerLabel.snp.makeConstraints({
            $0.leading.equalTo(nicknameLabel.snp.leading)
            $0.top.equalTo(profileImage.snp.centerY).offset(2.0)
        })

        separator.snp.makeConstraints({
            $0.top.equalTo(followerLabel.snp.top)
            $0.height.equalTo(11.0)
            $0.width.equalTo(1.0)
            $0.leading.equalTo(followerLabel.snp.trailing).offset(7.0)
        })

        followingLabel.snp.makeConstraints({
            $0.top.equalTo(followerLabel.snp.top)
            $0.leading.equalTo(separator.snp.trailing).offset(7.0)
        })
        
        bottomSeparator.snp.makeConstraints({
            $0.height.equalTo(4.0)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
    }
}
