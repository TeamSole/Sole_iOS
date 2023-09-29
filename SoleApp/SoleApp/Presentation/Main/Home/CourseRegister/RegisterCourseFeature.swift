//
//  RegisterCourseFeature.swift
//  SoleApp
//
//  Created by SUN on 9/29/23.
//

import ComposableArchitecture

struct RegisterCourseFeature: Reducer {
    typealias Course = CourseModelResponse.DataModel
    struct State: Equatable {
       
    }
    
    enum Action: Equatable {
        case didTappedDismissButton
    }
    
    @Dependency(\.courseClient) var CourseClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTappedDismissButton:
                return .run { _ in await dismiss() }
            }
        }
    }
}


