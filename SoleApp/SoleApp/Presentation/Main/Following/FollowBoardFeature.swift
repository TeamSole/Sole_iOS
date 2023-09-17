//
//  FollowBoardFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/17.
//

import ComposableArchitecture

struct FollowBoardFeature: Reducer {
    
    struct State: Equatable {
       
    }
    
    enum Action: Equatable {
        
    }
    
    @Dependency(\.scrapClient) var scrapClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            
            }
        }
    }
}
