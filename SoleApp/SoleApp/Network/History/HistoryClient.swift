//
//  HistoryClient.swift
//  SoleApp
//
//  Created by SUN on 2023/09/13.
//

import Dependencies

struct HistoryClient {
    var getUserHistory: () async throws -> (UserProfileHistoryModelResponse)
}

extension HistoryClient: DependencyKey {
    static var liveValue: HistoryClient  = HistoryClient(
        getUserHistory: {
            let request = API.makeDataRequest(HistoryTarget.getUserHistory)
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
