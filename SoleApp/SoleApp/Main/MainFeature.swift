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
        var selectedTab: Tab = .HOME
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
