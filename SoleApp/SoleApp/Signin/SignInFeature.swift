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
        var platform: String = ""
        var optionalSignUpAgreeTerms: SignUpAgreeTermsFeature.State?
    }
    
    enum Action: Equatable {
        case checkAleadyMember(String?)
        case checkAleadyMemberResponse(TaskResult<SignUpModelResponse>)
        case didTapSignWithKakao
        case didTapSignWithApple(token: String?)
        case optionalSignUpAgreeTerms(SignUpAgreeTermsFeature.Action)
        case setNavigaiton(isActive: Bool)
        case showSignUpView
        case showHome
       
    }
    
    @Dependency(\.signUpClient) var signUpClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .checkAleadyMember(let token):
                guard let token = token else { return .none }
                let parameter = CheckExistAccountRequest(accessToken: token)
                return .run { [platform = state.platform] send in
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
                
            case .didTapSignWithApple(let token):
                state.platform = "apple"
                return .send(.checkAleadyMember(token))
                
            case .didTapSignWithKakao:
                state.platform = "kakao"
                return .run { send in
                    await send(.checkAleadyMember(
                        await signUpClient.signInKakao()
                    ))
                }
                
            case .optionalSignUpAgreeTerms:
                return .none
                
            case .setNavigaiton(isActive: false):
                state.isShowSignUpView = false
                state.optionalSignUpAgreeTerms = nil
                return .none
                
            case .setNavigaiton(isActive: true):
                state.isShowSignUpView = true
                state.optionalSignUpAgreeTerms = SignUpAgreeTermsFeature.State()
                return .none
                
            case .showHome:
                return .none
                
            case .showSignUpView:
                return .send(.setNavigaiton(isActive: true))
            }
        }
        .ifLet(\.optionalSignUpAgreeTerms, action: /Action.optionalSignUpAgreeTerms) {
            SignUpAgreeTermsFeature()
        }
    }
}
 
