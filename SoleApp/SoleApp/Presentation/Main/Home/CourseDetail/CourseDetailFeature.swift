//
//  CourseDetailFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/12.
//

import ComposableArchitecture

struct CourseDetailFeature: Reducer { 
    typealias CourseDetail = CourseDetailModelResponse.DataModel
    struct State: Equatable {
        var courseDetail: CourseDetail = .init()
        var isCalledApi: Bool = false
        
        
        let courseId: Int
        
        init(courseId: Int) {
            self.courseId = courseId
        }
    }
    
    enum Action: Equatable {
        case didTappedDismissButton
        case getCourseDetail
        case getCourseDetailResponse(TaskResult<CourseDetailModelResponse>)
        case viewDidLoad
    }
    
    @Dependency(\.courseClient) var courseClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTappedDismissButton:
                return .run { _ in
                    await dismiss()
                }
                
            case .getCourseDetail:
                guard state.isCalledApi == false else { return .none }
                state.isCalledApi = true
                return .run { [courseId = state.courseId] send in
                    await send(.getCourseDetailResponse(
                        TaskResult {
                            try await courseClient.getCourseDetail(courseId)
                        }
                    ))
                }
                
            case .getCourseDetailResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true,
                   let data = response.data {
                    state.courseDetail = data
                }
                return .none
                
            case .getCourseDetailResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
            case .viewDidLoad:
                return .send(.getCourseDetail)
            }
        }
    }
}

