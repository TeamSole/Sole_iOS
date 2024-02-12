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
    typealias Location = LocationModelResponse.CurrentGps
    struct State: Equatable {
        @PresentationState var courseDetail: CourseDetailFeature.State?
        @PresentationState var courseSearch: CourseSearchFeature.State?
        @PresentationState var myPage: MyPageFeature.State?
        @PresentationState var registerCourse: RegisterCourseFeature.State?
        var courses: [Course] = []
        var location: Location = .init()
        var isCalledGetNextCoursesApi: Bool = false
        var recommendCourses: [RecommendCourse] = []
    }
    
    enum Action: Equatable {
        case courseDetail(PresentationAction<CourseDetailFeature.Action>)
        case courseSearch(PresentationAction<CourseSearchFeature.Action>)
        case didTappedCourseDetail(courseId: Int?)
        case didTappedCourseSearch
        case didTappedFloatingButton
        case didTappedMyPageButton
        case didTappedScrapButton(Course)
        case getCourses
        case getCoursesResponse(TaskResult<CourseModelResponse>)
        case getNextCourses
        case getNextCoursesResponse(TaskResult<CourseModelResponse>)
        case getLocation
        case getLocationResponse(TaskResult<CLLocationCoordinate2D>)
        case getRecommendedCourses
        case getRecommendedCoursesResponse(TaskResult<RecommendCourseModel>)
        case myPage(PresentationAction<MyPageFeature.Action>)
        case registerCourse(PresentationAction<RegisterCourseFeature.Action>)
        case scrap(courseId: Int, index: Int)
        case scrapResponse(TaskResult<BaseResponse>)
        /// 현재 위치 서버에 등록
        case setLocation(lat: Double, lng: Double)
        case setLocationResponse(TaskResult<LocationModelResponse>)
        case setTasty(place: [String], with: [String], tras: [String])
        case setTastyResponse(TaskResult<BaseResponse>)
        case viewDidLoad
        
    }
    
    @Dependency(\.homeClient) var homeClient
    @Dependency(\.locationClient) var locationClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .courseDetail:
                return .none
                
            case .courseSearch:
                return .none
                
            case .didTappedCourseDetail(let courseId):
                guard let courseId = courseId else { return .none }
                state.courseDetail = CourseDetailFeature.State(courseId: courseId)
                return .none
                
            case .didTappedCourseSearch:
                state.courseSearch = CourseSearchFeature.State()
                return .none
                
            case .didTappedFloatingButton:
                state.registerCourse = RegisterCourseFeature.State()
                return .none
                
            case .didTappedMyPageButton:
                state.myPage = MyPageFeature.State()
                return .none
                
            case .didTappedScrapButton(let course):
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
                
            case .getNextCourses:
                guard state.isCalledGetNextCoursesApi == false,
                      state.courses.last?.finalPage == false else { return .none }
                state.isCalledGetNextCoursesApi = true
                return .run { [courseId = state.courses.last?.courseId] send in
                    let parameter = CourseModelRequest(courseId: courseId)
                    await send(.getNextCoursesResponse(
                        TaskResult { try await homeClient.getNextCourses(parameter) }
                    ))
                }
                
            case .getNextCoursesResponse(.success(let response)):
                state.isCalledGetNextCoursesApi = false
                if response.success == true,
                   let data = response.data {
                    state.courses += data
                } else {
                    debugPrint(response.message ?? "")
                }
                return .none
                
            case .getNextCoursesResponse(.failure(let error)):
                state.isCalledGetNextCoursesApi = false
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
//                return .none
                return .run { send in
                    await send(.getRecommendedCoursesResponse(
                        TaskResult { try await homeClient.getRecommendedCourses() }
                    ))
                }
                
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
                
            case .registerCourse:
                return .none
                
            case .scrap(let courseId, let index):
                state.courses[index].like?.toggle()
                
                return .run { send in
                    await send(.setTastyResponse(
                        TaskResult { try await homeClient.scrap(courseId) }
                    ))
                }
                
            case .scrapResponse(.success(let response)):
                debugPrint(response)
                return .none
                
            case .scrapResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .setLocation(let lat, let lng):
                let locationModel = LocationModelRequest(latitude: lat, longitude: lng)
                return .run { send in
                    await send(.setLocationResponse(
                        TaskResult {
                            try await homeClient.setLocation(locationModel)
                        }
                    ))
                }
                
            case .setLocationResponse(.success(let response)):
                if response.success == true,
                   let location = response.data?.currentGps {
                    state.location = location
                    return .send(.getRecommendedCourses)
                }
                return .none
                
            case .setLocationResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
                
            case .setTasty(let placeCategory, let withCategory, let transCategory):
                
                return .run { send in
                    let parameter = CategoryModelRequest(placeCategories: placeCategory,
                                                         withCategories: withCategory,
                                                         transCategories: transCategory)
                    await send(.setTastyResponse(
                        TaskResult { try await homeClient.setTasty(parameter) }
                    ))
                }
                
            case .setTastyResponse(.success(let response)):
                debugPrint(response)
                return .none
                
            case .setTastyResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .viewDidLoad:
                return .merge([.send(.getCourses), .send(.getLocation)])
            }
            
        }
        .ifLet(\.$courseDetail, action: /Action.courseDetail) {
            CourseDetailFeature()
        }
        .ifLet(\.$courseSearch, action: /Action.courseSearch) {
            CourseSearchFeature()
        }
        .ifLet(\.$myPage, action: /Action.myPage) {
            MyPageFeature()
        }
        .ifLet(\.$registerCourse, action: /Action.registerCourse) {
            RegisterCourseFeature()
        }
    }
}


extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs == rhs
    }
    
    
}
