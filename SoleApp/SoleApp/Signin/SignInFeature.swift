//
//  SignInFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/07/28.
//

import ComposableArchitecture

struct SignInFeature: ReducerProtocol {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case didTapSignWithKakao
        case didTapSignWithApple
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapSignWithApple:
            return .none
        case .didTapSignWithKakao:
            return .none
        }
    }
}
 
