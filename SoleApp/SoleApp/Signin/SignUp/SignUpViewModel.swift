//
//  SignUpViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/17.
//

import Foundation
import Alamofire
import SwiftUI
import KakaoSDKUser
import AuthenticationServices

final class SignUpViewModel: NSObject, ObservableObject {
    var model: SignUpModel = SignUpModel()

    @Published var isSelectedFirstTerm: Bool = false
    @Published var isSelectedSecondTerm: Bool = false
    @Published var isSelectedThirdTerm: Bool = false
    @Published var isSelectedForthTerm: Bool = false
    
    @Published var loginPlaform: String = ""
    @Published var isAvailableNickname: Bool? = nil
    @Published var token: String = ""
    @Published var selectedImage: UIImage? = nil
    
    @Published var showSignUpView: Bool = false
    
    var isSelectedAllTerms: Bool {
        return isSelectedFirstTerm && isSelectedSecondTerm && isSelectedThirdTerm && isSelectedForthTerm
    }
    
    var isValidCheckingTerms: Bool {
        return isSelectedFirstTerm && isSelectedSecondTerm
    }
    var loginType: String = ""
    
    
}

extension SignUpViewModel {
    func didTapCheckAllTerms() {
        if isSelectedAllTerms {
            isSelectedFirstTerm = false
            isSelectedSecondTerm = false
            isSelectedThirdTerm = false
            isSelectedForthTerm = false
        } else {
            isSelectedFirstTerm = true
            isSelectedSecondTerm = true
            isSelectedThirdTerm = true
            isSelectedForthTerm = true
        }
    }
    
    func isValidNickName(name: String) {
        guard name.isEmpty == false else {
            isAvailableNickname = false
            return }
        
        guard name.count <= 10 else {
            isAvailableNickname = false
            return }
        
        let url: Alamofire.URLConvertible = URL(string:  K.baseUrl + K.Path.validCheckForNickName)!
        let header: HTTPHeaders = K.Header.jsonHeader
        let parameter = ["nickname": name]
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: header)
            .validate()
            .response { [weak self] response in
                switch response.result {
                case .success(let response):
                    let valid = String(decoding: response ?? Data(), as: UTF8.self)
                    self?.isAvailableNickname = valid == "false"
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
    }
    
    func kakaoLogin(complete: @escaping () -> ()) {
        loginPlaform = "kakao"
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    if let token = oauthToken?.accessToken {
                        self?.token = token
                        self?.checkExistAccount()
                        complete()
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {[weak self] (oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    if let token = oauthToken?.accessToken {
                        self?.token = token
                        self?.checkExistAccount()
                        complete()
                    }
                }
            }
        }
    }
    
    func signUp(complete: (() -> ())? = nil) {
        guard loginPlaform.isEmpty == false,
              token.isEmpty == false,
        let url = signUpUrl(platform: loginPlaform) else { return }
        
        let header: HTTPHeaders = K.Header.multiplatformHeader
        model.accessToken = token
        let subModel = model
        
        AF.upload(multipartFormData: { [weak self] multipart in
            let data = try? JSONEncoder().encode(subModel)
            multipart.append(data!, withName: "memberRequestDto")
            if let image = self?.selectedImage?.jpegData(compressionQuality: 0.1) {
                multipart.append(image, withName: "multipartFile", fileName: "\(image).jpeg", mimeType: "multipart/form-data")
            }
        }, to: url, method: .post, headers: header)
        .responseDecodable(of: SignUpModelResponse.self, completionHandler: { [weak self] response in
            switch response.result {
            case .success(let response):
                if let imageUrl = response.data?.profileImgUrl {
                    Utility.save(key: Constant.profileImage, value: imageUrl)
                }
                if let token = response.data?.accessToken,
                   let refreshToken = response.data?.refreshToken {
                    Utility.save(key: Constant.token, value: token)
                    Utility.save(key: Constant.refreshToken, value: refreshToken)
                    Utility.save(key: Constant.loginPlatform, value: self?.loginPlaform ?? "")
                    AppDelegate.shared.mainViewModel.existToken = true
                    AppDelegate.shared.mainViewModel.canShowMain = true
                    complete?()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func checkExistAccount() {
        guard loginPlaform.isEmpty == false,
              token.isEmpty == false else { return }
        let parameter = CheckExistAccountRequest(accessToken: token)
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.checkExistAccount + loginPlaform)!
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: SignUpModelResponse.self, completionHandler: { [weak self] response in
                switch response.result {
                case .success(let response):
                    if response.data?.check == true {
                        if let imageUrl = response.data?.profileImgUrl {
                            Utility.save(key: Constant.profileImage, value: imageUrl)
                        }
                        if let token = response.data?.accessToken,
                           let refreshToken = response.data?.refreshToken {
                            Utility.save(key: Constant.token, value: token)
                            Utility.save(key: Constant.refreshToken, value: refreshToken)
                            Utility.save(key: Constant.loginPlatform, value: self?.loginPlaform ?? "")
                            AppDelegate.shared.mainViewModel.existToken = true
                            AppDelegate.shared.mainViewModel.canShowMain = true
                        }
                    } else {
                        self?.showSignUpView = true
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        
        
    }
    
    
    func setSignupData() {
        model.serviceAccepted = isSelectedFirstTerm
        model.infoAccepted = isSelectedSecondTerm
        model.locationAccepted = isSelectedThirdTerm
        model.marketingAccepted = isSelectedForthTerm
    }
}

private extension SignUpViewModel {
    func signUpUrl(platform: String) -> URL? {
        if loginPlaform == "apple" {
            return URL(string:  K.baseUrl + K.Path.signUpApple)
        } else if loginPlaform == "kakao" {
            return URL(string:  K.baseUrl + K.Path.signUpKakao)
        } else {
            return nil
        }
    }
    
    private func checkAlreadyExistAccount(token: String) {
        
    }
}

extension SignUpViewModel: ASAuthorizationControllerDelegate {
    
    func performAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
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
            
            token = String(decoding: appleIDCredential.identityToken ?? Data(), as: UTF8.self)
            loginPlaform = "apple"
            checkExistAccount()
            default:
                break
            }
    }
}
