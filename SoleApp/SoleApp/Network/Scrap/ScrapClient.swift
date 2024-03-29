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
    var getScrapList: (_ isDefaultFolder: Bool, _ folderId: Int) async throws -> (ScrapListModelResponse)
    var removeFolder: (_ folderId: Int) async throws -> (BaseResponse)
    var removeScraps: (_ isDefaultFolder: Bool, _ folderId: Int, _ scrapsCourseIds: [Int]) async throws -> (BaseResponse)
    var renameFolder: (_ folderId: Int, ScrapRenameFolderRequest) async throws -> (BaseResponse)
    var scrap: (_ courseId: Int) async throws -> (BaseResponse)
    
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
        },
        getScrapList: { isDefaultFolder, folderId in
            let request = API.makeDataRequest(ScrapTarget.getScrapList(isDefaultFolder: isDefaultFolder, folderId: folderId))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: ScrapListModelResponse.self)
        },
        removeFolder: { folderId in
            let request = API.makeDataRequest(ScrapTarget.removeFolder(folderId: folderId))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: BaseResponse.self)
        },
        removeScraps: { isDefaultFolder, folderId, scrapsCourseIds in
            let request = API.makeDataRequest(ScrapTarget.removeScraps(isDefaultFolder: isDefaultFolder,
                                                                       folderId: folderId,
                                                                       scrapsCourseIds: scrapsCourseIds))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: BaseResponse.self)
        },
        renameFolder: { folderId, parameter in
            let request = API.makeDataRequest(ScrapTarget.renameFolder(folderId: folderId, parameter))
            let data = try await request.validate().serializingData().value
            return try API.responseDecodeToJson(data: data, response: BaseResponse.self)
        },
        scrap: { courseId in
            let request = API.makeDataRequest(ScrapTarget.scrap(courseId: courseId))
            let data = await request.validate().serializingData().result
            switch data {
            case .success(_):
                return BaseResponse(status: 200, success: true)
                
            case .failure(let error):
                return BaseResponse(message: error.localizedDescription, status: 0, success: false)
            }
        }
    )
}

extension DependencyValues {
    var scrapClient: ScrapClient {
        get { self[ScrapClient.self] }
        set { self[ScrapClient.self] = newValue }
    }
}
