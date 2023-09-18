//
//  FollowingUserListFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/18.
//

import ComposableArchitecture

struct FollowingUserListFeature: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
       
    }
    
    @Dependency(\.followClient) var followClient
    @Dependency(\.scrapClient) var scrapClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            
            }
        }
    }
}
