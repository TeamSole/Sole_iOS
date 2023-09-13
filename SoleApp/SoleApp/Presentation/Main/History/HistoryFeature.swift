//
//  HistoryFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/13.
//

import ComposableArchitecture

struct HistoryFeature: Reducer {
    typealias ProfileDescription = UserProfileHistoryModelResponse.DataModel
    typealias Histories = [HistoryModelResponse.DataModel]
    struct State: Equatable {
        var userHistoryDescription: UserProfileHistoryModelResponse.DataModel = .init()
    }
    
    enum Action: Equatable {
        case getUserHistoryDescription
        case getUserHistoryDescriptionResponse(TaskResult<UserProfileHistoryModelResponse>)
        case viewDidLoad
    }
    
    @Dependency(\.historyClient) var historyClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .getUserHistoryDescription:
                return .run { send in
                    await send(.getUserHistoryDescriptionResponse(
                        TaskResult { try await historyClient.getUserHistory() }
                    ))
                }
            
            case .getUserHistoryDescriptionResponse(.success(let response)):
                if response.success == true,
                   let data = response.data {
                    state.userHistoryDescription = data
                    return .none
                } else {
                    return .none
                }
                
            case .getUserHistoryDescriptionResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
                
            case .viewDidLoad:
                return .merge([.send(.getUserHistoryDescription)])
            }
        }
    }
}
