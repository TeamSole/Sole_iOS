//
//  HomeFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/23.
//

import ComposableArchitecture
import CoreLocation

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
        case getLocation
        case getLocationResponse(TaskResult<CLLocationCoordinate2D>)
        case getRecommendedCourses
        case getRecommendedCoursesResponse(TaskResult<RecommendCourseModel>)
        case myPage(PresentationAction<MyPageFeature.Action>)
        case viewDidLoad
        
    }
    
    @Dependency(\.homeClient) var homeClient
    @Dependency(\.locationClient) var locationClient
    
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
                
            case .getLocation:
                return .run { send in
                    // 원래는 locationClient에서 위치 정보를 호출해야하나
                    // 테스트 용도로 run에서 호출해봄
                    
//                        let locationManager = LocationManager()
//                        let info = try await locationManager.updateLocation()
                    // 여기 아래로 호출 안됨
//                    print("------------")
//                    print(info)
                        await send(.getLocationResponse(
                            TaskResult { try await locationClient.updateLocation() }
                        ))
                    
                }
                
            case .getLocationResponse(.success(let location)):
                debugPrint(location)
                print("--------------------")
                return .none
                
            case .getLocationResponse(.failure(let error)):
                debugPrint(error)
                return .none
                
            case .getRecommendedCourses:
                return .none
//                return .run { send in
//                    await send(.getRecommendedCoursesResponse(
//                        TaskResult { try await homeClient.getCourses() }
//                    ))
//                }
                
            case .getRecommendedCoursesResponse(.success(let response)):
                if response.success == true,
                   let data = response.data {
                    state.recommendCourses = data
                } else {
                    debugPrint(response.message ?? "")
                }
                return .none
                
            case .getRecommendedCoursesResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .myPage:
                return .none
                
            case .viewDidLoad:
                return .merge([.send(.getCourses), .send(.getLocation)])
            }
            
        }
        .ifLet(\.$myPage, action: /Action.myPage) {
            MyPageFeature()
        }
    }
}


extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs == rhs
    }
    
    
}
