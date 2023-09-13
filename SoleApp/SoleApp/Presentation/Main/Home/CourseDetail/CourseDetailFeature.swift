//
//  CourseDetailFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/12.
//

import ComposableArchitecture

struct CourseDetailFeature: Reducer {
    struct State: Equatable {
        var courseId: Int
        
        init(courseId: Int) {
            self.courseId = courseId
        }
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

