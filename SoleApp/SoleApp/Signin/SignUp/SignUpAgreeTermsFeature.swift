//
//  SignUpAgreeTermsFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/10.
//

import ComposableArchitecture

struct SignUpAgreeTermsFeature: Reducer {
    struct State: Equatable {
        var isSelectedAllTerms: Bool {
            return isSelectedFirstTerm && isSelectedSecondTerm && isSelectedThirdTerm && isSelectedForthTerm
        }
        
        var isSelectedFirstTerm: Bool = false
        var isSelectedSecondTerm: Bool = false
        var isSelectedThirdTerm: Bool = false
        var isSelectedForthTerm: Bool = false
        @PresentationState var signUpUserInfo: SignUpUserInfoFeature.State?
        var isValidCheckingTerms: Bool {
            return isSelectedFirstTerm && isSelectedSecondTerm
        }
    }
    
    enum Action: Equatable {
        case didTappedAllTermAgree
        case didTappedContinueButton
        case didTappedFirstTerm
        case didTappedSecondTerm
        case didTappedThirdTerm
        case didTappedForthTerm
        case didTappedBackButton
        case signUpUserInfo(PresentationAction<SignUpUserInfoFeature.Action>)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTappedAllTermAgree:
                didTapCheckAllTerms()
                return .none
                
            case .didTappedContinueButton:
                guard state.isValidCheckingTerms == true else { return .none }
                state.signUpUserInfo = SignUpUserInfoFeature.State()
                return .none
                
            case .didTappedFirstTerm:
                state.isSelectedFirstTerm.toggle()
                return .none
                
            case .didTappedSecondTerm:
                state.isSelectedSecondTerm.toggle()
                return .none
                
            case .didTappedThirdTerm:
                state.isSelectedThirdTerm.toggle()
                return .none
                
            case .didTappedForthTerm:
                state.isSelectedForthTerm.toggle()
                return .none
                
            case .didTappedBackButton:
                return .run { _ in await self.dismiss() }
                
            case .signUpUserInfo:
                return .none
            }
            
            func didTapCheckAllTerms() {
                if state.isSelectedAllTerms == true {
                    state.isSelectedFirstTerm = false
                    state.isSelectedSecondTerm = false
                    state.isSelectedThirdTerm = false
                    state.isSelectedForthTerm = false
                } else {
                    state.isSelectedFirstTerm = true
                    state.isSelectedSecondTerm = true
                    state.isSelectedThirdTerm = true
                    state.isSelectedForthTerm = true
                }
            }
        }
        .ifLet(\.$signUpUserInfo, action: /Action.signUpUserInfo) {
            SignUpUserInfoFeature()
        }
    }
    
    
}
