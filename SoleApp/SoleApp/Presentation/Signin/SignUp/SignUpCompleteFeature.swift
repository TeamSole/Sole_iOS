//
//  SignUpCompleteFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/21.
//

import ComposableArchitecture


struct SignUpCompleteFeature: Reducer {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case moveMain
        case viewAppear
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .moveMain:
            return .none
            
        case .viewAppear:
            return .run { send in
                try await Task.sleep(nanoseconds: 3_000_000_000)
                await send(.moveMain)
            }
        }
    }
}
