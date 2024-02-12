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
        var selectedCouseId: Int
        
        init(selectedCouseId: Int) {
            self.folders = []
            self.selectedCouseId = selectedCouseId
        }
    }
    
    enum Action: Equatable {
        case getScrapFolderList
        case getScrapFolderListResponse(TaskResult<ScrapFolderResponseModel>)
        case viewDidLoad
    }
    
    @Dependency(\.scrapClient) var scrapClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
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
                
            case .viewDidLoad:
                return .send(.getScrapFolderList)
            
            }
        }
    }
}