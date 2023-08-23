//
//  MainFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/22.
//

import ComposableArchitecture

enum Tab {
    case HOME
    case HISTORY
    case FOLLOWING
    case SCRAP
}

struct MainFeature: Reducer {
    struct State: Equatable {
        var home: HomeFeature.State = .init()
        var selectedTab: Tab = .HOME
    }
    
    enum Action: Equatable {
        case home(HomeFeature.Action)
        case selectTab(Tab)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectTab(let tab):
                state.selectedTab = tab
                return .none
            }
        }
    }
}
