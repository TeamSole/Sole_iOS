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
        @PresentationState var followUser: FollowUserFeature.State?
    }
    
    enum Action: Equatable {
        case didTappedDismissButton
        case didTappedUser(socialId: String?, memberId: Int?)
        /// 팔로우
        case follow(categoryIndex: Int, memberId: Int?)
        case followResponse(TaskResult<BaseResponse>)
        
        case followUser(PresentationAction<FollowUserFeature.Action>)
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
                
            case .didTappedUser(let socialId, let memberId):
                guard let socialId = socialId,
                      let memberId = memberId else { return .none }
                state.followUser = FollowUserFeature.State(socialId: socialId, memberId: memberId)
                return .none
                
            case .follow(let categoryIndex, let memberId):
                guard let memberId = memberId else { return .none }
                if categoryIndex == 0 {
                    if let index = state.followers.firstIndex(where: { $0.member?.memberId == memberId}) {
                        state.followers[index].followStatus = state.followers[index].followStatus == "FOLLOWING" ? "FOLLOWER" : "FOLLOWING"
                    }
                } else if categoryIndex == 1 {
                    if let index = state.follows.firstIndex(where: { $0.member?.memberId == memberId}) {
                        state.follows[index].followStatus = state.follows[index].followStatus == "FOLLOWING" ? "FOLLOWER" : "FOLLOWING"
                    }
                }
                return .run { send in
                    await send(.followResponse(
                        TaskResult { try await followClient.follow(memberId)}))
                }
                
            case .followResponse(.success(let response)):
                if response.success == true {
                    
                }
                return .none
                
            case .followUser:
                return .none
                
            case .followResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
            
                
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
        .ifLet(\.$followUser, action: /Action.followUser) {
            FollowUserFeature()
        }
    }
}
