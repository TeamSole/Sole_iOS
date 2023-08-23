//
//  MyPageFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/23.
//

import ComposableArchitecture

struct MyPageFeature: Reducer {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case didTapDismissButton
    }
    
    @Dependency(\.dismiss) var dismiss
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTapDismissButton:
                return .run { send in
                    await dismiss()
                }
            }
        }
    }
}
