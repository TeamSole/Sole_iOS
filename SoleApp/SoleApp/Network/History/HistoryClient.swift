//
//  HistoryClient.swift
//  SoleApp
//
//  Created by SUN on 2023/09/13.
//

import Dependencies

struct HistoryClient {
    var getUserHistories: (HistoryModelRequest?) async throws -> (HistoryModelResponse)
    var getUserHistoryDescription: () async throws -> (UserProfileHistoryModelResponse)
}

extension HistoryClient: DependencyKey {
    static var liveValue: HistoryClient  = HistoryClient(
        getUserHistories: { query in
            let request = API.makeDataRequest(HistoryTarget.getUserHistories(query))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: HistoryModelResponse.self)
            
        },
        getUserHistoryDescription: {
            let request = API.makeDataRequest(HistoryTarget.getUserHistoryDescription)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: UserProfileHistoryModelResponse.self)
        })
}

extension DependencyValues {
    var historyClient: HistoryClient {
        get { self[HistoryClient.self] }
        set { self[HistoryClient.self] = newValue }
    }
}
