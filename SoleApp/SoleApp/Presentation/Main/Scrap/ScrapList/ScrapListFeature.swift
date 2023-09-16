//
//  ScrapListFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/17.
//

import ComposableArchitecture

struct ScrapListFeature: Reducer {
    typealias Scrap = ScrapListModelResponse.DataModel
    struct State: Equatable {
        var folderId: Int
        var folderName: String
        var isDefaultFolder: Bool
        var scrapList: [Scrap] = []
        
        init(folderId: Int, folderName: String) {
            self.folderId = folderId
            self.folderName = folderName
            self.isDefaultFolder = folderName == StringConstant.defaultFolder
        }
    }
    
    enum Action: Equatable {
        case getScrapList
        case getScrapListResponse(TaskResult<ScrapListModelResponse>)
        case viewDidLoad
    }
    
    @Dependency(\.scrapClient) var scrapClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .getScrapList:
                return .run { [isDefaultFolder = state.isDefaultFolder,
                               folderId = state.folderId] send in
                    await send(.getScrapListResponse(
                        TaskResult { try await scrapClient.getScrapList(isDefaultFolder, folderId) }))
                }
                
            case .getScrapListResponse(.success(let response)):
                if response.success == true,
                   let data = response.data {
                    state.scrapList = data
                }
                return .none
                
            case .getScrapListResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .viewDidLoad:
                return .send(.getScrapList)
            }
        }
    }
}
