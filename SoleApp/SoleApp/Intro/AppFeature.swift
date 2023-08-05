//
//  AppFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/07/30.
//

import ComposableArchitecture

struct AppFeature: Reducer {
    enum State: Equatable {
        case signUp
        case main
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
