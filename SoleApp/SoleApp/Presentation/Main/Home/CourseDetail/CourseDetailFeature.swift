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
        /// 팔로우
        case follow
        case followResponse(TaskResult<BaseResponse>)
        
        case getCourseDetail
        case getCourseDetailResponse(TaskResult<CourseDetailModelResponse>)
        /// 코스 삭제
        case removeCourse
        case removeCourseResponse(TaskResult<BaseResponse>)
        /// 스크랩
        case scrap
        case scrapResponse(TaskResult<BaseResponse>)
        case viewDidLoad
    }
    
    @Dependency(\.courseClient) var courseClient
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.followClient) var followClient
    @Dependency(\.scrapClient) var scrapClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTappedDismissButton:
                return .run { _ in
                    await dismiss()
                }
                
            case .follow:
                guard let memberId = state.courseDetail.writer?.memberId,
                      state.isCalledApi == false,
                      state.courseDetail.checkWriter == false else { return .none}
                state.isCalledApi = true
                state.courseDetail.followStatus = state.courseDetail.isFollowing == true ? "FOLLOWER" : "FOLLOWING"
               
                return .run { send in
                    await send(.followResponse(
                        TaskResult { try await followClient.follow(memberId)}))
                }
                
            case .followResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true {
                    
                }
                return .none
                
            case .followResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
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
                
            case .removeCourse:
                guard state.isCalledApi == false,
                      state.courseDetail.checkWriter == false else { return .none }
                state.isCalledApi = true
                return .run { [courseId = state.courseId] send in
                    await send(.scrapResponse(
                        TaskResult { try await scrapClient.scrap(courseId)}))
                }
                
            case .removeCourseResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true {
                    return .send(.didTappedDismissButton)
                }
                return .none
                
            case .removeCourseResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                state.courseDetail.like?.toggle()
                return .none
                
            case .scrap:
                guard state.isCalledApi == false else { return .none }
                state.isCalledApi = true
                state.courseDetail.like?.toggle()
                return .run { [courseId = state.courseId] send in
                    await send(.scrapResponse(
                        TaskResult { try await scrapClient.scrap(courseId)}))
                }
                
            case .scrapResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true {
                  
                } else {
                    state.courseDetail.like?.toggle()
                }
                return .none
                
            case .scrapResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                state.courseDetail.like?.toggle()
                return .none
                
            case .viewDidLoad:
                return .send(.getCourseDetail)
            }
        }
    }
}

