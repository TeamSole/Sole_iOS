//
//  AppFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/07/30.
//

import ComposableArchitecture

struct AppFeature: Reducer {
    enum State: Equatable {
        case signIn(SignInFeature.State)
        case main(MainFeature.State)
        case loading(IntroFeature.State)
        public init() {
            self = .loading(IntroFeature.State()) //.home(HomeFeature.State())//
        }
    }
    
    enum Action: Equatable {
        case signIn(SignInFeature.Action)
        case main(MainFeature.Action)
        case loading(IntroFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .signIn(.optionalSignUpAgreeTerms(.presented(.signUpUserInfo(.presented(.signUpComplete(.presented(.moveMain))))))):
                state = .main(MainFeature.State())
                return .none
                
            case .signIn(.moveMain):
                state = .main(MainFeature.State())
                return .none
                
            case .main(.moveToSignIn):
                state = .signIn(SignInFeature.State())
                return .none
                
            case .main(.home(.myPage(.presented(.moveSignIn)))):
                state = .signIn(SignInFeature.State())
                return .none
                
            case .main(.home(.myPage(.presented(.accountSetting(.presented(.moveSignIn)))))):
                state = .signIn(SignInFeature.State())
                return .none
                
            case .loading(.moveToHome):
                state = .main(MainFeature.State())
                return .none
                
            case .loading(.moveToSignInView):
                state = .signIn(SignInFeature.State())
                return .none
                
            default:
                return .none
            }
        }
        .ifCaseLet(/State.signIn, action: /Action.signIn) {
            SignInFeature()
        }
        .ifCaseLet(/State.main, action: /Action.main) {
            MainFeature()
        }
        .ifCaseLet(/State.loading, action: /Action.loading) {
            IntroFeature()
        }
        
    }
}
