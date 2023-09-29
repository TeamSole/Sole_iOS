//
//  HistoryFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/13.
//

import ComposableArchitecture

struct HistoryFeature: Reducer {
    typealias ProfileDescription = UserProfileHistoryModelResponse.DataModel
    typealias Histories = [HistoryModelResponse.DataModel]
    struct State: Equatable {
        @PresentationState var courseDetail: CourseDetailFeature.State?
        var isCalledApi: Bool = false
        @PresentationState var registerCourse: RegisterCourseFeature.State?
        var selectedPlaceParameter: [String] = []
        var selectedWithParameter: [String] = []
        var selectedVehiclesParameter: [String] = []
        var userHistories: Histories = []
        var userHistoryDescription: UserProfileHistoryModelResponse.DataModel = .init()
        var isEmptyUserHistorParameters: Bool {
            return selectedWithParameter.isEmpty == true &&
            selectedWithParameter.isEmpty == true &&
            selectedVehiclesParameter.isEmpty == true
            
        }
       
    }
    
    enum Action: Equatable {
        /// 코스 상세 연결
        case courseDetail(PresentationAction<CourseDetailFeature.Action>)
        /// 코스 목록 클릭시 호출
        case didTappedCourseDetail(courseId: Int)
        /// 플로팅 버튼 클릭
        case didTappedFloatingButton
        /// 사용자 기록 가져오기 api 호출
        case getNextUserHistories
        /// 사용자 기록 가져오기 api 호출 리스폰스
        case getNextUserHistoriesResponse(TaskResult<HistoryModelResponse>)
        /// 사용자 기록 가져오기 api 호출
        case getUserHistories
        /// 사용자 기록 가져오기 api 호출 리스폰스
        case getUserHistoriesResponse(TaskResult<HistoryModelResponse>)
        /// 사용자 기록 설명 가져오기 api 호출
        case getUserHistoryDescription
        /// 사용자 기록 설명 가져오기 api 호출 리스폰스
        case getUserHistoryDescriptionResponse(TaskResult<UserProfileHistoryModelResponse>)
        case registerCourse(PresentationAction<RegisterCourseFeature.Action>)
        case setHistoryParameter(places: [String], with: [String], vehicles: [String])
        
        case viewDidLoad
    }
    
    @Dependency(\.historyClient) var historyClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .courseDetail:
                return .none
                
            case .didTappedCourseDetail(let courseId):
                state.courseDetail = CourseDetailFeature.State(courseId: courseId)
                return .none
                
            case .didTappedFloatingButton:
                state.registerCourse = RegisterCourseFeature.State()
                return .none
                
            case .getNextUserHistories:
                guard state.isCalledApi == false,
                state.userHistories.last?.finalPage == false,
                let courseId = state.userHistories.last?.courseId else { return .none }
                let parameter = isEmptyUserHistorParameters() == true ? nil : CategoryModelRequest(placeCategories: state.selectedPlaceParameter,
                                                                                                       withCategories: state.selectedWithParameter,
                                                                                                       transCategories: state.selectedVehiclesParameter)
                
                let query = HistoryModelRequest(courseId: courseId)
                return .run { send in
                    await send(.getUserHistoriesResponse(
                        TaskResult { try await historyClient.getUserHistories(query, parameter) }
                    ))
                }
                
            case .getNextUserHistoriesResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true,
                   let data = response.data {
                    state.userHistories += data
                    return .none
                } else {
                    return .none
                }
                
            case .getNextUserHistoriesResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
            case .getUserHistories:
                guard state.isCalledApi == false else { return .none }
                state.isCalledApi = true
                let parameter = isEmptyUserHistorParameters() == true ? nil : CategoryModelRequest(placeCategories: state.selectedPlaceParameter,
                                                                                                       withCategories: state.selectedWithParameter,
                                                                                                       transCategories: state.selectedVehiclesParameter)
                print(isEmptyUserHistorParameters())
                return .run { send in
                    await send(.getUserHistoriesResponse(
                        
                        TaskResult { try await historyClient.getUserHistories(nil, parameter) }
                    ))
                }
                
            case .getUserHistoriesResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true,
                   let data = response.data {
                    state.userHistories = data
                    return .none
                } else {
                    return .none
                }
                
            case .getUserHistoriesResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
                
            case .getUserHistoryDescription:
                return .run { send in
                    await send(.getUserHistoryDescriptionResponse(
                        TaskResult { try await historyClient.getUserHistoryDescription() }
                    ))
                }
            
            case .getUserHistoryDescriptionResponse(.success(let response)):
                if response.success == true,
                   let data = response.data {
                    state.userHistoryDescription = data
                    return .none
                } else {
                    return .none
                }
                
            case .getUserHistoryDescriptionResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .registerCourse:
                return .none
                
            case .setHistoryParameter(let places, let with, let vehicles):
                state.selectedPlaceParameter = places
                state.selectedWithParameter = with
                state.selectedVehiclesParameter = vehicles
                
                return .send(.getUserHistories)
                
            case .viewDidLoad:
                return .merge([.send(.getUserHistoryDescription),
                               .send(.getUserHistories)])
            }
            
            func isEmptyUserHistorParameters() -> Bool {
                return state.selectedPlaceParameter.isEmpty == true &&
                state.selectedWithParameter.isEmpty == true &&
                state.selectedVehiclesParameter.isEmpty == true
            }
        }
        .ifLet(\.$registerCourse, action: /Action.registerCourse) {
            RegisterCourseFeature()
        }
    }
}
