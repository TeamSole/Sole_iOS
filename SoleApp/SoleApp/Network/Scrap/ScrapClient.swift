//
//  ScrapClient.swift
//  SoleApp
//
//  Created by SUN on 2023/09/15.
//

import Dependencies

struct ScrapClient {
    var addFolder: (ScrapAddFolderModelRequest) async throws -> (BaseResponse)
    var getScrapFolderList: () async throws -> (ScrapFolderResponseModel)
}

extension ScrapClient: DependencyKey {
    static var liveValue: ScrapClient = ScrapClient(
        addFolder: { parameter in
            let request = API.makeDataRequest(ScrapTarget.addFolder(parameter))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: BaseResponse.self)
        },
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
