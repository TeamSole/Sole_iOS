//
//  FollowUserFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/20.
//

import ComposableArchitecture

struct FollowUserFeature: Reducer {
    typealias UserDetail = FollowUserModelResponse.DataModel
    typealias Course = FollowUserModelResponse.Place
    struct State: Equatable {
        var memberId: Int
        var socialId: String
        
        var isCalledApi: Bool = false
        var popularCourse: Course? = nil
        var recentCourses: [Course]? = []
        var userDetail: UserDetail = .init()
        
        
        init(socialId: String, memberId: Int) {
            self.socialId = socialId
            self.memberId = memberId
        }
    }
    
    enum Action: Equatable {
        case didTappedDismissButton
        case getUserDetail
        case getUserDetailResponse(TaskResult<FollowUserModelResponse>)
        case viewDidLoad
    }
    
    @Dependency(\.followClient) var followClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTappedDismissButton:
                return .run { _ in await dismiss() }
                
            case .getUserDetail:
                guard state.isCalledApi == false else { return .none }
                state.isCalledApi = true
                return .run { [socialId = state.socialId] send in
                    await send(.getUserDetailResponse(
                        TaskResult {
                            try await followClient.getUserDetail(socialId, nil)
                        }
                    ))
                }
                
            case .getUserDetailResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true,
                   let data = response.data {
                    state.userDetail = data
                    state.popularCourse = data.popularCourse
                    state.recentCourses = data.recentCourses
                }
                return .none
                
            case .getUserDetailResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
            case .viewDidLoad:
                return .send(.getUserDetail)
            }
        }
    }
}

