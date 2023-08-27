//
//  MyPageFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/23.
//

import ComposableArchitecture

struct MyPageFeature: Reducer {
    struct State: Equatable {
        typealias AccountInfo = MyPageResponse.DataModel
        var accountInfo: AccountInfo = .init()
    }
    
    enum Action: Equatable {
        case accountInfoResponse(TaskResult<MyPageResponse>)
        case didTapDismissButton
        case viewWillAppear
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.myPageClient) var myPageClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .accountInfoResponse(.success(let response)):
                guard let data = response.data else { return .none}
                state.accountInfo = data
                return .none
                
            case .accountInfoResponse(.failure(let error)):
                debugPrint(error)
                return .none
                
            case .didTapDismissButton:
                return .run { send in
                    await dismiss()
                }
                
            case .viewWillAppear:
                return .run { send in
                    await send(.accountInfoResponse(
                        TaskResult {
                            try await myPageClient.getAccountInfo()
                        }
                    ))
                }
            }
        }
    }
}
