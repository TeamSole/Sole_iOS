//
//  FollowUserFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/20.
//

import ComposableArchitecture

struct FollowUserFeature: Reducer {
    struct State: Equatable {
        var socialId: String
        var memberId: Int
        
        init(socialId: String, memberId: Int) {
            self.socialId = socialId
            self.memberId = memberId
        }
    }
    
    enum Action: Equatable {
    
    }
    
    @Dependency(\.followClient) var followClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            
            }
        }
    }
}

