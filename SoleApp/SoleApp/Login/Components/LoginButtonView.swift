//
//  LoginButtonView.swift
//  SoleApp
//
//  Created by SUN on 2023/02/09.
//

import UIKit
import SnapKit

final class LoginButtonView: UIView {
    var title: String
    var color: UIColor
    var textColor: UIColor
    var imageName: String
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: self.imageName))
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }()
    
    init(title: String, color: UIColor = .white, textColor: UIColor = .white, imageName: String) {
        self.title = title
        self.color = color
        self.textColor = textColor
        self.imageName = imageName
        super.init(frame: .zero)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [imageView,
        titleLabel]
            .forEach({self.addSubview($0)})
        self.contentMode = .center
        self.backgroundColor = color
        self.layer.cornerRadius = 5.0
        imageView.snp.makeConstraints({
            $0.height.equalTo(37.0)
            $0.width.equalTo(imageView.snp.height)
            $0.leading.equalToSuperview().inset(10.0)
            $0.centerY.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}
