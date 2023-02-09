//
//  LoginViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/06.
//

import UIKit
import SnapKit
import SwiftUI

final class LoginViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let image = UIImage(named: "sole_splash")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        return imageView
    }()
    
    private let loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.contentMode = .center
        return stackView
    }()
    
    private let kakaoLoginButtonView: UIView = {
        let loginButton = LoginButtonView(title: "Kakao로 시작하기",
                                          color: .yellow_FBE520,
                                          textColor: .black,
                                          imageName: "kakao_icon")
        return loginButton
    }()
    private let appleLoginButtonView: UIView =  {
        let loginButton = LoginButtonView(title: "Apple로 시작하기",
                                          color: .black,
                                          textColor: .white,
                                          imageName: "apple_icon")
        return loginButton
    }()
    
    private let callInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보처리방침\n회원 정보 문의 : sole.admin@gmail.com"
        label.textColor = .gray_D6D6D6
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension LoginViewController {
    private func setupUI() {
        [logoImageView,
        loginStackView,
        callInfoLabel]
            .forEach({ view.addSubview($0) })
        
        [kakaoLoginButtonView,
         appleLoginButtonView]
            .forEach({loginStackView.addArrangedSubview($0)})
        
        logoImageView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(UIScreen.main.bounds.height/15)
        })
        
        loginStackView.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(90.0)
        })
        
        kakaoLoginButtonView.snp.makeConstraints({
            $0.height.equalTo(45.0)
        })
        
        appleLoginButtonView.snp.makeConstraints({
            $0.height.equalTo(45.0)
        })
        
        callInfoLabel.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20.0)
        })
    }
}

struct LoginViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            LoginViewController()
        }
    }
}
