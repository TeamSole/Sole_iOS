//
//  IntroFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/22.
//

import ComposableArchitecture

struct IntroFeature: Reducer {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case checkExistToken
        case moveToHome
        case moveToSignInView
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .checkExistToken:
                if Utility.load(key: Constant.token).isEmpty == true {
                    return .send(.moveToSignInView)
                } else {
                    return .send(.moveToHome)
                }
                
            case .moveToHome:
                return .none
                
            case .moveToSignInView:
                return .none
            }
        }
    }
}

