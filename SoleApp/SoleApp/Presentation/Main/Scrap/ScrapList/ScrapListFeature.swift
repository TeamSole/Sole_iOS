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
        var temporaryFolderName: String = ""
        
        init(folderId: Int, folderName: String) {
            self.folderId = folderId
            self.folderName = folderName
            self.isDefaultFolder = folderName == StringConstant.defaultFolder
        }
    }
    
    enum Action: Equatable {
        
        case didTappedDismissButton
        /// 스크랩 리스트 불러오기 Api 호출
        case getScrapList
        /// 스크랩 리스트 불러오기 Api response
        case getScrapListResponse(TaskResult<ScrapListModelResponse>)
        /// 폴더 삭제  Api 호출
        case removeFolder
        /// 폴더 삭제  Api response
        case removeFolderResponse(TaskResult<BaseResponse>)
        /// 폴더 이름 변경  Api 호출
        case renameFolder(folderName: String)
        /// 폴더 이름 변경  Api response
        case renameFolderResponse(TaskResult<BaseResponse>)
        case viewDidLoad
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.scrapClient) var scrapClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTappedDismissButton:
                return .run { send in
                    await dismiss()
                }
                
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
                
            case .removeFolder:
                return .run { [folderId = state.folderId] send in
                    await send(.removeFolderResponse(
                        TaskResult { try await scrapClient.removeFolder(folderId) }))
                }
                
            case .removeFolderResponse(.success(let response)):
                if response.success == true {
                    return .send(.didTappedDismissButton)
                }
                return .none
                
            case .removeFolderResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .renameFolder(let folderName):
                guard folderName.isEmpty == false else { return .none }
                state.temporaryFolderName = folderName
                return .run { [folderId = state.folderId] send in
                    let parameter = ScrapRenameFolderRequest(scrapFolderName: folderName)
                    await send(.renameFolderResponse(
                        TaskResult { try await scrapClient.renameFolder(folderId, parameter) }))
                }
                
            case .renameFolderResponse(.success(let response)):
                if response.success == true {
                    state.folderName = state.temporaryFolderName
                }
                return .none
                
            case .renameFolderResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
                
            case .viewDidLoad:
                return .send(.getScrapList)
            }
        }
    }
}
