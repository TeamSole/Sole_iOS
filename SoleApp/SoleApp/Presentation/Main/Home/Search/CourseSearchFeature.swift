//
//  CourseSearchFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/24.
//

import ComposableArchitecture

struct CourseSearchFeature: Reducer {
    typealias Course = CourseModelResponse.DataModel
    struct State: Equatable {
        @PresentationState var courseDetail: CourseDetailFeature.State?
        @PresentationState var scrapFeature: ScrapFeature.State?
        var courses: [Course] = []
        var isCalledApi: Bool = false
        var searchText: String = ""
        var selectedPlaceParameter: [String] = []
        var selectedWithParameter: [String] = []
        var selectedVehiclesParameter: [String] = []
        var selectedLocation: [LocationModel] = []
        
        var title: String = ""
        
        var isEmptyUserHistorParameters: Bool {
            return selectedWithParameter.isEmpty == true &&
            selectedWithParameter.isEmpty == true &&
            selectedVehiclesParameter.isEmpty == true &&
            selectedLocation.isEmpty == true
        }
    }
    
    enum Action: Equatable {
        case clearSearchText
        /// 코스 상세 연결
        case courseDetail(PresentationAction<CourseDetailFeature.Action>)
        /// 코스 목록 클릭시 호출
        case didTappedCourseDetail(courseId: Int)
        case didTappedDismissButton
        case didTappedScrapButton(Course)
        case scrap(courseId: Int)
        case scrapFeature(PresentationAction<ScrapFeature.Action>)
        case scrapCancel(courseId: Int)
        case scrapResponse(TaskResult<BaseResponse>)
        case searchCourse(searchText: String)
        case searchCourseResponse(TaskResult<CourseModelResponse>)
        case searchCourseNextPage
        case searchCourseNextPageResponse(TaskResult<CourseModelResponse>)
        
        case setHistoryParameter(searchText: String, places: [String], with: [String], vehicles: [String], locations: [LocationModel])
    }
    
    @Dependency(\.courseClient) var CourseClient
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.scrapClient) var scrapClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .clearSearchText:
                state.searchText = ""
                return .none
                
            case .courseDetail:
                return .none
                
            case .didTappedCourseDetail(let courseId):
                state.courseDetail = CourseDetailFeature.State(courseId: courseId)
                return .none
                
            case .didTappedDismissButton:
                return .run { _ in await dismiss() }
                
            case .didTappedScrapButton(let course):
                if course.like == true {
                    return .send(.scrapCancel(courseId: course.courseId ?? 0))
                } else {
                    guard let courseId = course.courseId else { return .none }
                    
                    state.scrapFeature = ScrapFeature.State(selectedCourseId: courseId)
                    return .none
                }

                
            case .scrap(let courseId):
                guard state.isCalledApi == false else { return .none }
                state.isCalledApi = true
                if let index = state.courses.firstIndex(where: { $0.courseId == courseId }) {
                    state.courses[index].like?.toggle()
                }
                return .run { send in
                    await send(.scrapResponse(
                        TaskResult { try await scrapClient.scrap(courseId)}))
                }
                
            case .scrapFeature(.presented(.completeScrap(let courseId))):
                state.scrapFeature = nil
                if let index = state.courses.firstIndex(where: { $0.courseId == courseId }) {
                    state.courses[index].like?.toggle()
                }
                
                return .none
                
            case .scrapFeature:
                return .none
                
            case .scrapCancel(let courseId):
                if let index = state.courses.firstIndex(where: { $0.courseId == courseId}) {
                    state.courses[index].like?.toggle()
                }
                
                return .run { send in
                    await send(.scrapResponse(
                        TaskResult { try await scrapClient.scrapToFolder(courseId, nil) }
                    ))
                }
                
            case .scrapResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true {
                  
                }
                return .none
                
            case .scrapResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
            case .searchCourse(let searchText):
                guard searchText.isEmpty == false else { state.title = StringConstant.pleaseTypeSearchText
                    return .none
                }
                
                guard state.isCalledApi == false else { return .none }
                state.isCalledApi = true
                state.searchText = searchText
                let query = SearchCourseRequest(searchWord: searchText, placeCategories: state.selectedPlaceParameter.joined(separator: ",").isEmpty ? nil : state.selectedPlaceParameter.joined(separator: ","),
                                                withCategories: state.selectedWithParameter.joined(separator: ",").isEmpty ? nil : state.selectedWithParameter.joined(separator: ","),
                                                transCategories: state.selectedVehiclesParameter.joined(separator: ",").isEmpty ? nil : state.selectedVehiclesParameter.joined(separator: ","),
                                                regions: state.selectedLocation.map({ $0.locationCode }).joined(separator: ",").isEmpty ? nil : state.selectedLocation.map({ $0.locationCode }).joined(separator: ","))
                return .run { send in
                    await send(.searchCourseResponse(
                        TaskResult { try await CourseClient.searchCourse(query)}))
                }
                
            case .searchCourseResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true,
                   let data = response.data {
                    if data.isEmpty {
                        state.title = StringConstant.emptyCourseSearched
                    } else {
                        state.title = ""
                    }
                    state.courses = data
                }
                return .none
                
            case .searchCourseResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
            case .searchCourseNextPage:
                guard state.searchText.isEmpty == false else { state.title = StringConstant.pleaseTypeSearchText
                    return .none
                }
                
                guard state.isCalledApi == false,
                      state.courses.last?.finalPage == false,
                      let courseId = state.courses.last?.courseId else { return .none }
                state.isCalledApi = true
                let query = SearchCourseRequest(searchWord: state.searchText,
                                                placeCategories: state.selectedPlaceParameter.joined(separator: ",").isEmpty ? nil : state.selectedPlaceParameter.joined(separator: ","),
                                                withCategories: state.selectedWithParameter.joined(separator: ",").isEmpty ? nil : state.selectedWithParameter.joined(separator: ","),
                                                transCategories: state.selectedVehiclesParameter.joined(separator: ",").isEmpty ? nil : state.selectedVehiclesParameter.joined(separator: ","),
                                                regions: state.selectedLocation.map({ $0.locationCode }).joined(separator: ",").isEmpty ? nil : state.selectedLocation.map({ $0.locationCode }).joined(separator: ","))
                return .run { send in
                    await send(.searchCourseNextPageResponse(
                        TaskResult { try await CourseClient.searchCourse(query)}))
                }
                
            case .searchCourseNextPageResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true,
                   let data = response.data {
                    state.courses += data
                }
                return .none
                
            case .searchCourseNextPageResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
            case .setHistoryParameter(let searchText, let places, let with, let vehicles, let locations):
                state.selectedPlaceParameter = places
                state.selectedWithParameter = with
                state.selectedVehiclesParameter = vehicles
                state.selectedLocation = locations
                
                return .send(.searchCourse(searchText: searchText))
            }
        }
        .ifLet(\.$courseDetail, action: /Action.courseDetail) {
            CourseDetailFeature()
        }
        .ifLet(\.$scrapFeature, action: /Action.scrapFeature) {
            ScrapFeature()
        }
    }
}
