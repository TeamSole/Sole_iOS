//
//  AccountSettingFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/27.
//

import ComposableArchitecture

struct AccountSettingFeature: Reducer {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case didTappedDismissButton
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTappedDismissButton:
                return .run { send in
                    await dismiss()
                }
            }
        }
    }
}
