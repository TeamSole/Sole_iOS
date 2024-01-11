//
//  SignUpClient.swift
//  SoleApp
//
//  Created by SUN on 2023/08/05.
//

import Foundation
import ComposableArchitecture
import Alamofire
import KakaoSDKUser
import UIKit

struct SignUpClient {
    var checkAleadyMember: @Sendable (CheckExistAccountRequest, String) async throws -> (SignUpModelResponse)
    var checkValidationForNickname: @Sendable (CheckValidationForNicknameRequest) async throws -> (Bool)
    var signInKakao: @Sendable () async -> (String?)
    var signUp: @Sendable (SignUpModel, UIImage?) async throws -> (SignUpModelResponse)
}

extension SignUpClient: DependencyKey {
    static var liveValue = SignUpClient(
        checkAleadyMember: { parameter, platform in
            let request = API.makeDataRequest(SignUpTarget.checkAleardyMember(parameter, platform), isNeedInterceptor: false)
            let data = try await request.validate().serializingData().value
            
            return try API.responseDecodeToJson(data: data, response: SignUpModelResponse.self)
            
        },
        checkValidationForNickname: { parameter in
            let request = API.makeDataRequest(SignUpTarget.checkValidationForNickname(parameter), isNeedInterceptor: false)
            let data = try await request.validate().serializingData().value
            let isAleadyExist = String(decoding: data, as: UTF8.self)
            return (isAleadyExist == "false")
        },
        signInKakao: {
            return await SignUpClient.kakaoLogin()
        },
        signUp: { parameter, image in
            
            let url = K.baseUrl + K.Path.signUp(platform: parameter.platform)
            let header: HTTPHeaders = K.Header.multiplatformHeader
            let data = try await API.session.upload(multipartFormData: { multipart in
                let data = try? JSONEncoder().encode(parameter)
                multipart.append(data!, withName: "memberRequestDto")
                if let image = image?.jpegData(compressionQuality: 0.1) {
                    multipart.append(image, withName: "multipartFile", fileName: "\(image).jpeg", mimeType: "multipart/form-data")
                }
            }, to: url, method: .post, headers: header)
            .validate()
            .serializingData()
            .value
            
            return try API.responseDecodeToJson(data: data, response: SignUpModelResponse.self)
        }
    )
    
    func signUpUrl(platform: String) -> URL? {
        if platform == "apple" {
            return URL(string:  K.baseUrl + K.Path.signUpApple)
        } else if platform == "kakao" {
            return URL(string:  K.baseUrl + K.Path.signUpKakao)
        } else {
            return nil
        }
    }
}

extension SignUpClient {
    static func kakaoLogin() async -> String? {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return await withCheckedContinuation { coutinuation in
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    if let error = error {
                        debugPrint(error)
                        coutinuation.resume(returning: nil)
                    }
                    else {
                        debugPrint("loginWithKakaoTalk() success.")
                        coutinuation.resume(returning: oauthToken?.accessToken)
                    }
                }
            }
           
        } else {
            return await withCheckedContinuation { coutinuation in
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    if let error = error {
                        debugPrint(error)
                        coutinuation.resume(returning: nil)
                    }
                    else {
                        debugPrint("loginWithKakaoTalk() success.")
                        coutinuation.resume(returning: oauthToken?.accessToken)
                    }
                }
            }
        }
    }
}

extension DependencyValues {
    var signUpClient: SignUpClient {
        get { self[SignUpClient.self] }
        set { self[SignUpClient.self] = newValue }
    }
}
