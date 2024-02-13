//
//  ScrapFeature.swift
//  SoleApp
//
//  Created by SUN on 2/11/24.
//

import ComposableArchitecture

struct ScrapFeature: Reducer {
    typealias Folder = ScrapFolderResponseModel.DataModel
    struct State: Equatable {
        var folders: [Folder]
        var selectedCourseId: Int
        
        init(selectedCourseId: Int) {
            self.folders = []
            self.selectedCourseId = selectedCourseId
        }
    }
    
    enum Action: Equatable {
        case completeScrap(courseId: Int)
        case getScrapFolderList
        case getScrapFolderListResponse(TaskResult<ScrapFolderResponseModel>)
        
        case scrap(folderId: Int)
        
        case scrapResponse(TaskResult<BaseResponse>)
        
        case viewDidLoad
    }
    
    @Dependency(\.scrapClient) var scrapClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .completeScrap(let courseId):
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
                
            case .scrap(let folderId):
                
                let courseId = state.selectedCourseId
                return .run { send in
                    await send(.scrapResponse(
                        TaskResult { try await scrapClient.scrapToFolder(courseId, folderId) }
                    ))
                }
                
            case .scrapResponse(.success(let response)):
                debugPrint(response)
                return .send(.completeScrap(courseId: state.selectedCourseId))
                
            case .scrapResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .viewDidLoad:
                return .send(.getScrapFolderList)
            
            }
        }
    }
}
