//
//  SignInFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/07/28.
//

import ComposableArchitecture

struct SignInFeature: Reducer {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case checkAleadyMember(String?)
        case checkAleadyMemberResponse(TaskResult<SignUpModelResponse>)
        case didTapSignWithKakao
        case didTapSignWithApple
    }
    
    @Dependency(\.signUpClient) var signUpClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .checkAleadyMember(let token):
            guard let token = token else { return .none }
            return .none
        case .checkAleadyMemberResponse(let result):
            return .none
        case .didTapSignWithApple:
            
            return .none
        case .didTapSignWithKakao:
            return .run { send in
                await send(.checkAleadyMember(
                    await signUpClient.signInKakao()
                ))
            }
        }
    }
}
 
