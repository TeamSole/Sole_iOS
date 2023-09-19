//
//  FollowClient.swift
//  SoleApp
//
//  Created by SUN on 2023/09/17.
//

import Dependencies

struct FollowClient {
    var getCoursesOfFollowers: () async throws -> (FollowBoardModelResponse)
    var getFollowers: () async throws -> (FollowListModelResponse)
    var getFollows: () async throws -> (FollowListModelResponse)
}

extension FollowClient: DependencyKey {
    static var liveValue: FollowClient = FollowClient(
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
        }
    )
}

extension DependencyValues {
    var followClient: FollowClient {
        get { self[FollowClient.self] }
        set { self[FollowClient.self] = newValue }
    }
}
