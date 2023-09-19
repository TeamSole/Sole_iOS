//
//  FollowingUserListFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/18.
//

import ComposableArchitecture

struct FollowingUserListFeature: Reducer {
    typealias FollowUser = FollowListModelResponse.DataModel
    struct State: Equatable {
        var followers: [FollowUser] = []
        var follows: [FollowUser] = []
    }
    
    enum Action: Equatable {
        case didTappedDismissButton
        /// 팔로워 한 사람 목록 Api 호출
        case getFollowers
        case getFollowersResponse(TaskResult<FollowListModelResponse>)
        /// 팔로우 한 사람 목록 api 호출
        case getFollows
        case getFollowsResponse(TaskResult<FollowListModelResponse>)
        case viewDidLoad
    }
    
    @Dependency(\.followClient) var followClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTappedDismissButton:
                return .run { _ in
                    await dismiss()
                }
                
            case .getFollowers:
                return .run { send in
                    await send(.getFollowersResponse(
                        TaskResult { try await followClient.getFollowers()}))
                }
                
            case .getFollowersResponse(.success(let response)):
                if response.success == true,
                   let data = response.data {
                    state.followers = data
                }
                return .none
                
            case .getFollowersResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .getFollows:
                return .run { send in
                    await send(.getFollowsResponse(
                        TaskResult { try await followClient.getFollows()}))
                }
                
            case .getFollowsResponse(.success(let response)):
                if response.success == true,
                   let data = response.data {
                    state.follows = data
                }
                return .none
                
            case .getFollowsResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .viewDidLoad:
                return .merge([.send(.getFollows), .send(.getFollowers)])
            }
        }
    }
}
