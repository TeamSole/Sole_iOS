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
        var courses: [Course] = []
        var isCalledApi: Bool = false
        var searchText: String = ""
        var title: String = ""
    }
    
    enum Action: Equatable {
        case clearSearchText
        case didTappedDismissButton
        case scrap(courseId: Int)
        case scrapResponse(TaskResult<BaseResponse>)
        case searchCourse(searchText: String)
        case searchCourseResponse(TaskResult<CourseModelResponse>)
        case searchCourseNextPage
        case searchCourseNextPageResponse(TaskResult<CourseModelResponse>)
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
                
            case .didTappedDismissButton:
                return .run { _ in await dismiss() }
                
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
                return .run { [searchText = state.searchText] send in
                    let query = SearchCourseRequest(searchWord: searchText)
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
                return .run { [searchText = state.searchText] send in
                    let query = SearchCourseRequest(searchWord: searchText, courseId: courseId)
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
            }
        }
    }
}
