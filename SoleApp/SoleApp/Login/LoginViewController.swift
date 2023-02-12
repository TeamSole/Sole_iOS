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
        let image = UIImage(named: "sole_splash")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
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
    
    private lazy var kakaoLoginButtonView: UIView = {
        let loginButton = LoginButtonView(title: "Kakao로 시작하기",
                                          color: .yellow_FBE520,
                                          textColor: .black,
                                          imageName: "kakao_icon")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLoginButton))
        loginButton.addGestureRecognizer(tapGesture)
        return loginButton
    }()
    private lazy var appleLoginButtonView: UIView =  {
        let loginButton = LoginButtonView(title: "Apple로 시작하기",
                                          color: .white,
                                          textColor: .black,
                                          imageName: "apple_icon")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLoginButton))
        loginButton.addGestureRecognizer(tapGesture)
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
        view.backgroundColor = .black
        [logoImageView,
        loginStackView,
        callInfoLabel]
            .forEach({ view.addSubview($0) })
        
        [kakaoLoginButtonView,
         appleLoginButtonView]
            .forEach({loginStackView.addArrangedSubview($0)})
        
        logoImageView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
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
    
    @objc private func didTapLoginButton() {
        let vc = SignUpFirstStepViewController()
        vc.navigationController?.navigationItem.title = "회원가입"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

struct LoginViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            LoginViewController()
        }
    }
}
