//
//  ProfileSectionView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/11.
//

import UIKit
import Kingfisher
import SnapKit

final class ProfileSectionView: UIView {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: ""),
                              placeholder: UIImage(named: "profile24"))
        return imageView
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .pretendardMedium(size: 14.0)
        return label
    }()
    
    private let followerNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로우 몇"
        label.textColor = .black
        label.font = .pretendardRegular(size: 12.0)
        return label
    }()
    
    private let followingNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로우 몇"
        label.textColor = .black
        label.font = .pretendardRegular(size: 12.0)
        return label
    }()
    
    private let followDividerView = UIView()
    private let bottomDividerView = UIView()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("팔로우", for: .normal)
        button.setTitle("팔로잉", for: .selected)
        button.setBackgroundColor(.blue_4708FA, for: .normal)
        button.setBackgroundColor(.white, for: .selected)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.blue_4708FA, for: .selected)
        button.titleLabel?.font = .pretendardMedium(size: 12.0)
        button.layer.borderColor = UIColor.blue_4708FA.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapFollowButton(_:)), for: .touchUpInside)
        return button
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
        followDividerView.backgroundColor = .black
        bottomDividerView.backgroundColor = .gray_EDEDED
        [profileImageView,
        nickNameLabel,
        followerNumberLabel,
        followingNumberLabel,
         followDividerView,
         followButton,
        bottomDividerView].forEach({ addSubview($0) })
        
        profileImageView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40.0)
            $0.leading.equalToSuperview()
        })
        
        nickNameLabel.snp.makeConstraints({
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12.0)
            $0.bottom.equalTo(profileImageView.snp.centerY).offset(1.5)
            $0.trailing.equalTo(followButton.snp.leading)
        })
        
        followerNumberLabel.snp.makeConstraints({
            $0.leading.equalTo(nickNameLabel)
            $0.top.equalTo(profileImageView.snp.centerY).offset(1.5)
        })
        
        followDividerView.snp.makeConstraints({
            $0.height.equalTo(11.0)
            $0.width.equalTo(1.0)
            $0.leading.equalTo(followerNumberLabel.snp.trailing).offset(7.0)
            $0.centerY.equalTo(followerNumberLabel.snp.centerY)
        })
        
        followingNumberLabel.snp.makeConstraints({
            $0.centerY.equalTo(followerNumberLabel.snp.centerY)
            $0.leading.equalTo(followDividerView.snp.trailing).offset(7.0)
        })
        
        followButton.snp.makeConstraints({
            $0.trailing.centerY.equalToSuperview()
            $0.width.equalTo(62.0)
            $0.height.equalTo(20.0)
        })
        
        bottomDividerView.snp.makeConstraints({
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        })
    }
    
    @objc private func didTapFollowButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}
