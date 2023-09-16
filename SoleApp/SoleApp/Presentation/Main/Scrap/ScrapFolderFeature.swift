//
//  ScrapFolderFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/15.
//

import ComposableArchitecture

struct ScrapFolderFeature: Reducer {
    typealias Folder = ScrapFolderResponseModel.DataModel
    struct State: Equatable {
        var folders: [Folder] = []
        @PresentationState var scrapList: ScrapListFeature.State?
    }
    
    enum Action: Equatable {
        case addFolder(folderName: String)
        case addFolderResponse(TaskResult<BaseResponse>)
        case didTappedScrapFolder(folderId: Int, folderName: String)
        case getScrapFolderList
        case getScrapFolderListResponse(TaskResult<ScrapFolderResponseModel>)
        case scrapList(PresentationAction<ScrapListFeature.Action>)
        case viewDidLoad
    }
    
    @Dependency(\.scrapClient) var scrapClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addFolder(let folderName):
                return .run { send in
                    let parameter = ScrapAddFolderModelRequest(scrapFolderName: folderName)
                    await send(.addFolderResponse(
                        TaskResult { try await scrapClient.addFolder(parameter) }))
                }
                
            case .addFolderResponse(.success(let response)):
                if response.success == true {
                    return .send(.getScrapFolderList)
                }
                return .none
                
            case .addFolderResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .didTappedScrapFolder(let folderId, let folderName):
                state.scrapList = ScrapListFeature.State(folderId: folderId, folderName: folderName)
                return .none
                
            case .getScrapFolderList:
                return .run { send in
                    await send(.getScrapFolderListResponse(
                        TaskResult { try await scrapClient.getScrapFolderList()}))
                }
                
            case .getScrapFolderListResponse(.success(let response)):
                if response.success == true,
                   let data = response.data {
                    state.folders = data
                }
                return .none
                
            case .getScrapFolderListResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .scrapList:
                return .none
                
            case .viewDidLoad:
                return .send(.getScrapFolderList)
            }
        }
        .ifLet(\.$scrapList, action: /Action.scrapList) {
            ScrapListFeature()
        }
    }
}
