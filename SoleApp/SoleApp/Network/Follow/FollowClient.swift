//
//  FollowClient.swift
//  SoleApp
//
//  Created by SUN on 2023/09/17.
//

import Dependencies

struct FollowClient {
    var follow: (_ memberId: Int) async throws -> (BaseResponse)
    var getCoursesOfFollowers: () async throws -> (FollowBoardModelResponse)
    var getFollowers: () async throws -> (FollowListModelResponse)
    var getFollows: () async throws -> (FollowListModelResponse)
    var getUserDetail: (_ socialId: String, _ query: FollowUserModelRequest?) async throws -> (FollowUserModelResponse)
}

extension FollowClient: DependencyKey {
    static var liveValue: FollowClient = FollowClient(
        follow: { memberId in
            let request = API.makeDataRequest(FollowTarget.follow(memberId: memberId))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: BaseResponse.self)
        },
        getCoursesOfFollowers: {
            let request = API.makeDataRequest(FollowTarget.getCoursesOfFollowers)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: FollowBoardModelResponse.self)
        },
        getFollowers: {
            let request = API.makeDataRequest(FollowTarget.getFollowers)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: FollowListModelResponse.self)
        },
        getFollows: {
            let request = API.makeDataRequest(FollowTarget.getFollows)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: FollowListModelResponse.self)
        },
        getUserDetail: { socialId, query in
            let request = API.makeDataRequest(FollowTarget.getUserDetail(socialId: socialId, query: query))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: FollowUserModelResponse.self)
        }
        
    )
}

extension DependencyValues {
    var followClient: FollowClient {
        get { self[FollowClient.self] }
        set { self[FollowClient.self] = newValue }
    }
}
