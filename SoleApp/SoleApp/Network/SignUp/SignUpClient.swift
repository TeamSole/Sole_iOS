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

struct SignUpClient {
    var checkAleadyMember: @Sendable (CheckExistAccountRequest, String) async throws -> (SignUpModelResponse)
    var checkValidationForNickname: @Sendable (CheckValidationForNicknameRequest) async throws -> (Bool)
    var signInKakao: @Sendable () async -> (String?)
}

extension SignUpClient: DependencyKey {
    static var liveValue = SignUpClient(
        checkAleadyMember: { parameter, platform in
            let request = API.makeDataRequest(SignUpTarget.checkAleardyMember(parameter, platform))
            let data = try await request.validate().serializingData().value
            
            return try API.responseDecodeToJson(data: data, response: SignUpModelResponse.self)
            
        },
        checkValidationForNickname: { parameter in
            let request = API.makeDataRequest(SignUpTarget.checkValidationForNickname(parameter))
            let data = try await request.validate().serializingData().value
            let isAleadyExist = String(decoding: data, as: UTF8.self)
            return (isAleadyExist == "false")
        },
        signInKakao: {
            return await SignUpViewModel.kakaoLogin()
        })
}

extension DependencyValues {
    var signUpClient: SignUpClient {
        get { self[SignUpClient.self] }
        set { self[SignUpClient.self] = newValue }
    }
}
