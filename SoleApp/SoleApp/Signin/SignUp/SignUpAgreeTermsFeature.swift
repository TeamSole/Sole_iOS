//
//  SignUpAgreeTermsFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/10.
//

import ComposableArchitecture

struct SignUpAgreeTermsFeature: Reducer {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case didTappedBackButton
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTappedBackButton:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
