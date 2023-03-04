//
//  LoginViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/06.
//

import UIKit
import SnapKit
import SwiftUI
import KakaoSDKUser
import Alamofire
import AuthenticationServices

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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLoginWithKakaoButton))
        loginButton.addGestureRecognizer(tapGesture)
        return loginButton
    }()
    private lazy var appleLoginButtonView: UIView =  {
        let loginButton = LoginButtonView(title: "Apple로 시작하기",
                                          color: .black,
                                          textColor: .white,
                                          imageName: "apple_icon")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAppleLoginButton))
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
        view.backgroundColor = .white
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
    
    @objc private func didTapLoginWithKakaoButton() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    let vc = SignUpFirstStepViewController()
                    vc.navigationController?.navigationItem.title = "회원가입"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    self.kakaoAccess(token: oauthToken?.accessToken ?? "")
//                    let vc = SignUpFirstStepViewController()
//                    vc.navigationController?.navigationItem.title = "회원가입"
//                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc private func didTapAppleLoginButton() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    private func kakaoAccess(token: String) {
        let url: Alamofire.URLConvertible = URL(string:  K.baseUrl + "api/members/kakao/signup")!
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data"
        ]
        
//        let model = SignUpModel()
        let subModel = Model(accessToken: token)
        let subModel2 = OauthRequest(accessToken: token)
        
//        let parameter: [String: Any] = [
//            "infoAccepted": subModel.infoAccepted,
//            "marketingAccepted": subModel.marketingAccepted,
//            "serviceAccepted": subModel.serviceAccepted,
//            "nickname": subModel.nickname,
//            "accessToken": subModel.accessToken,
//        ]
//        let parameter: [String: Any] = [
//            "memberRequestDto": subModel
//        ]
        
        AF.upload(multipartFormData: { multipart in
//            for (key, value) in parameter {
                let data = try? JSONEncoder().encode(subModel)
                multipart.append(data!, withName: "memberRequestDto")
                print(multipart)
//                            }
        }, to: url, method: .post, headers: header)
        .response { response in
            switch response.result {
            case .success(let response):
                print(String(decoding: response ?? Data(), as: UTF8.self))
            case .failure(let error):
                print(error.localizedDescription)
                
            default:
                break
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    
                // 계정 정보 가져오기
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                    
                print("User ID : \(userIdentifier)")
                print("User Email : \(email ?? "")")
                print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
            print("\(appleIDCredential.identityToken)")
            

            default:
                break
            }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

struct LoginViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            LoginViewController()
        }
    }
}
