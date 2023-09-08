//
//  HomeFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/23.
//

import ComposableArchitecture

struct HomeFeature: Reducer {
    typealias RecommendCourse = RecommendCourseModel.DataModel
    typealias Course = CourseModelResponse.DataModel
    struct State: Equatable {
        @PresentationState var myPage: MyPageFeature.State?
        var courses: [Course] = []
        var recommendCourses: [RecommendCourse] = []
    }
    
    enum Action: Equatable {
        case didTapMyPageButton
        case getCourses
        case getCoursesResponse(TaskResult<CourseModelResponse>)
        case getRecommendedCourses
        case myPage(PresentationAction<MyPageFeature.Action>)
        case viewDidLoad
        
    }
    
    @Dependency(\.homeClient) var homeClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTapMyPageButton:
                state.myPage = MyPageFeature.State()
                return .none
                
            case .getCourses:
                return .run { send in
                    await send(.getCoursesResponse(
                        TaskResult { try await homeClient.getCourses() }
                    ))
                }
                
            case .getCoursesResponse(.success(let response)):
                if response.success == true,
                   let data = response.data {
                    state.courses = data
                } else {
                    debugPrint(response.message ?? "")
                }
                return .none
                
            case .getCoursesResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .getRecommendedCourses:
                return .none
                
            case .myPage:
                return .none
                
            case .viewDidLoad:
                return .merge([.send(.getCourses), .send(.getRecommendedCourses)])
            }
            
        }
        .ifLet(\.$myPage, action: /Action.myPage) {
            MyPageFeature()
        }
    }
}
