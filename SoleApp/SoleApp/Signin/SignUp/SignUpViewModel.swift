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

final class SignUpViewModel: ObservableObject {
    var model: SignUpModel = SignUpModel()

    @Published var isSelectedFirstTerm: Bool = false
    @Published var isSelectedSecondTerm: Bool = false
    @Published var isSelectedThirdTerm: Bool = false
    
    @Published var loginPlaform: String = ""
    @Published var isAvailableNickname: Bool? = nil
    @Published var token: String = ""
    @Published var selectedImage: UIImage? = nil
    
    var isSelectedAllTerms: Bool {
        return isSelectedFirstTerm && isSelectedSecondTerm && isSelectedThirdTerm
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
        } else {
            isSelectedFirstTerm = true
            isSelectedSecondTerm = true
            isSelectedThirdTerm = true
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
    
    func signUp(complete: (() -> ())? = nil) {
        guard loginPlaform.isEmpty == false,
              token.isEmpty == false,
        let url = signUpUrl(platform: loginPlaform) else { return }
        
        let header: HTTPHeaders = K.Header.multiplatformHeader
        let subModel = SignUpModel(accessToken: token)
        
        AF.upload(multipartFormData: { [weak self] multipart in
            let data = try? JSONEncoder().encode(subModel)
            multipart.append(data!, withName: "memberRequestDto")
            if let image = self?.selectedImage?.pngData() {
                multipart.append(image, withName: "multipartFile", fileName: "\(image).png", mimeType: "image/png")
            }
        }, to: url, method: .post, headers: header)
        .responseDecodable(of: SignUpModelResponse.self, completionHandler: { response in
            switch response.result {
            case .success(let response):
                if let token = response.data?.accessToken {
                    Utility.save(key: Constant.token, value: token)
                    AppDelegate.shared.mainViewModel.existToken = true
                    AppDelegate.shared.mainViewModel.canShowMain = true
                    complete?()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func setSignupData() {
        model.serviceAccepted = isSelectedFirstTerm
        model.infoAccepted = isSelectedSecondTerm
        model.marketingAccepted = isSelectedThirdTerm
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
    
    
}
