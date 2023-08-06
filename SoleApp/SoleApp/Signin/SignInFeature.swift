//
//  SignInFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/07/28.
//

import ComposableArchitecture

struct SignInFeature: Reducer {
    struct State: Equatable {
        var isShowSignUpView: Bool = false
    }
    
    enum Action: Equatable {
        case checkAleadyMember(String?)
        case checkAleadyMemberResponse(TaskResult<SignUpModelResponse>)
        case didTapSignWithKakao
        case didTapSignWithApple
        case showSignUpView
        case showHome
    }
    
    @Dependency(\.signUpClient) var signUpClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .checkAleadyMember(let token):
            guard let token = token else { return .none }
            let parameter = CheckExistAccountRequest(accessToken: token)
            let platform = "kakao"
            return .run { send in
                await send(.checkAleadyMemberResponse(
                    await TaskResult {
                        try await signUpClient.checkAleadyMember(parameter, platform)
                    }
                ))
            }
        case .checkAleadyMemberResponse(.success(let response)):
            if response.data?.check == true {
                if let imageUrl = response.data?.profileImgUrl {
                    Utility.save(key: Constant.profileImage, value: imageUrl)
                }
                if let token = response.data?.accessToken,
                   let refreshToken = response.data?.refreshToken {
                    Utility.save(key: Constant.token, value: token)
                    Utility.save(key: Constant.refreshToken, value: refreshToken)
                    Utility.save(key: Constant.loginPlatform, value: response.data?.social ?? "")
                }
                // TODO: switch store로 연경해야함
                return .none
            } else {
                return .send(.showSignUpView)
            }
            
        case .checkAleadyMemberResponse(.failure(let error)):
            debugPrint(error.localizedDescription)
            return .none
        case .didTapSignWithApple:
            
            return .none
        case .didTapSignWithKakao:
            return .run { send in
                await send(.checkAleadyMember(
                    await signUpClient.signInKakao()
                ))
            }
        case .showHome:
            return .none
        case .showSignUpView:
            state.isShowSignUpView = true
            return .none
        }
    }
}
 
