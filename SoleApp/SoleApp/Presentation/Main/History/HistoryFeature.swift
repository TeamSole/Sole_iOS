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
        var isCalledApi: Bool = false
        var userHistories: Histories = []
        var userHistoryDescription: UserProfileHistoryModelResponse.DataModel = .init()
    }
    
    enum Action: Equatable {
        /// 사용자 기록 가져오기 api 호출
        case getUserHistories
        /// 사용자 기록 가져오기 api 호출 리스폰스
        case getUserHistoriesResponse(TaskResult<HistoryModelResponse>)
        /// 사용자 기록 설명 가져오기 api 호출
        case getUserHistoryDescription
        /// 사용자 기록 설명 가져오기 api 호출 리스폰스
        case getUserHistoryDescriptionResponse(TaskResult<UserProfileHistoryModelResponse>)
        case viewDidLoad
    }
    
    @Dependency(\.historyClient) var historyClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .getUserHistories:
                guard state.isCalledApi == false else { return .none }
                state.isCalledApi = true
                return .run { send in
                    await send(.getUserHistoriesResponse(
                        TaskResult { try await historyClient.getUserHistories(nil) }
                    ))
                }
                
            case .getUserHistoriesResponse(.success(let response)):
                state.isCalledApi = false
                if response.success == true,
                   let data = response.data {
                    state.userHistories = data
                    return .none
                } else {
                    return .none
                }
                
            case .getUserHistoriesResponse(.failure(let error)):
                state.isCalledApi = false
                debugPrint(error.localizedDescription)
                return .none
                
                
            case .getUserHistoryDescription:
                return .run { send in
                    await send(.getUserHistoryDescriptionResponse(
                        TaskResult { try await historyClient.getUserHistoryDescription() }
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
                return .merge([.send(.getUserHistoryDescription),
                               .send(.getUserHistories)])
            }
        }
    }
}
