//
//  ScrapClient.swift
//  SoleApp
//
//  Created by SUN on 2023/09/15.
//

import Dependencies

struct ScrapClient {
    var getScrapFolderList: () async throws -> (ScrapFolderResponseModel)
}

extension ScrapClient: DependencyKey {
    static var liveValue: ScrapClient = ScrapClient(
        getScrapFolderList: {
            let request = API.makeDataRequest(ScrapTarget.getScrapFolderList)
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: ScrapFolderResponseModel.self)
        })
}

extension DependencyValues {
    var scrapClient: ScrapClient {
        get { self[ScrapClient.self] }
        set { self[ScrapClient.self] = newValue }
    }
}
