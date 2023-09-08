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
        @PresentationState var accountSetting: AccountSettingFeature.State?
        var myPageViewCellData = MyPageCellData.allCases
    }
    
    enum Action: Equatable {
        case accountInfoResponse(TaskResult<MyPageResponse>)
        case accountSetting(PresentationAction<AccountSettingFeature.Action>)
        case didTappedAccountSettingButton
        case didTappedDismissButton
        case didTappedLogOutButton
        case logOutResponse(TaskResult<BaseResponse>)
        case moveSignIn
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
                
            case .accountSetting:
                return .none
                
            case .didTappedAccountSettingButton:
                state.accountSetting = AccountSettingFeature.State(accountInfo: state.accountInfo)
                return .none
                
            case .didTappedDismissButton:
                return .run { send in
                    await dismiss()
                }
                
            case .didTappedLogOutButton:
                return .run { send in
                    await send(.logOutResponse(
                        TaskResult {
                            try await myPageClient.logOut()
                        }
                    ))
                }
                
            case .logOutResponse(.success(let response)):
                if response.success == true {
                    resetAccountInfo()
                    return .send(.moveSignIn).animation(.default)
                } else {
                    return .none
                }
                
            case .logOutResponse(.failure(let error)):
                debugPrint(error)
                return .none
                
            case .moveSignIn:
                return .none
                
            case .viewWillAppear:
                return .run { send in
                    await send(.accountInfoResponse(
                        TaskResult {
                            try await myPageClient.getAccountInfo()
                        }
                    ))
                }
            }
            
            func resetAccountInfo() {
                Utility.delete(key: Constant.token)
                Utility.delete(key: Constant.refreshToken)
                Utility.delete(key: Constant.loginPlatform)
                Utility.delete(key: Constant.profileImage)
            }
        }
        .ifLet(\.$accountSetting, action: /Action.accountSetting) {
            AccountSettingFeature()
        }
    }
}
