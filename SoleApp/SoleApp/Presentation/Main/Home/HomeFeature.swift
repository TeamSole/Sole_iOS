//
//  HomeFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/23.
//

import ComposableArchitecture

struct HomeFeature: Reducer {
    struct State: Equatable {
        @PresentationState var myPage: MyPageFeature.State?
    }
    
    enum Action: Equatable {
        case didTapMyPageButton
        case myPage(PresentationAction<MyPageFeature.Action>)
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTapMyPageButton:
                state.myPage = MyPageFeature.State()
                return .none
                
            case .myPage:
                return .none
            }
            
        }
        .ifLet(\.$myPage, action: /Action.myPage) {
            MyPageFeature()
        }
    }
}
