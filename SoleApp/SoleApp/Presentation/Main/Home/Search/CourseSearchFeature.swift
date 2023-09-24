//
//  CourseSearchFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/24.
//

import ComposableArchitecture

struct CourseSearchFeature: Reducer {
   
    struct State: Equatable {
        var isCalledApi: Bool = false
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
