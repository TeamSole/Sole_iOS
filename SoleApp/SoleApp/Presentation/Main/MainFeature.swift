//
//  MainFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/22.
//

import ComposableArchitecture

struct MainFeature: Reducer {
    enum Tab: Equatable, Hashable {
        case HOME
        case HISTORY
        case FOLLOWING
        case SCRAP
    }
    
    struct State: Equatable {
        var home: HomeFeature.State = HomeFeature.State()
        var history: HistoryFeature.State = HistoryFeature.State()
        var follow: FollowBoardFeature.State = FollowBoardFeature.State()
        var scrap: ScrapFolderFeature.State = ScrapFolderFeature.State()
        var selectedTab: Tab = .HOME
    }
    
    enum Action: Equatable {
        case home(HomeFeature.Action)
        case history(HistoryFeature.Action)
        case follow(FollowBoardFeature.Action)
        case moveToSignIn
        case scrap(ScrapFolderFeature.Action)
        case selectTab(Tab)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .home:
                return .none
                
            case .history:
                return .none
                
            case .follow:
                return .none
                
            case .moveToSignIn:
                resetAccountInfo()
                return .none
                
            case .scrap:
                return .none
                
            case .selectTab(let tab):
                state.selectedTab = tab
                return .none
            }
            
            func resetAccountInfo() {
                Utility.delete(key: Constant.token)
                Utility.delete(key: Constant.refreshToken)
                Utility.delete(key: Constant.loginPlatform)
                Utility.delete(key: Constant.profileImage)
            }
        }
        Scope(state: \.home, action: /Action.home) {
            HomeFeature()
        }
        
        Scope(state: \.history, action: /Action.history) {
            HistoryFeature()
        }
        
        Scope(state: \.scrap, action: /Action.scrap) {
            ScrapFolderFeature()
        }
        
        Scope(state: \.follow, action: /Action.follow) {
            FollowBoardFeature()
        }
        
    }
}
