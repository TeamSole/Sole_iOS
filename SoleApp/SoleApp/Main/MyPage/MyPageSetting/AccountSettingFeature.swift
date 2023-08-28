//
//  AccountSettingFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/27.
//

import ComposableArchitecture
import UIKit

struct AccountSettingFeature: Reducer {
    struct State: Equatable {
        typealias AccountInfo = MyPageResponse.DataModel
        var accountInfo: AccountInfo
        var nicknameInput: String
        var descriptionInput: String
        var dummyDescription: String
        var isBusyAPI: Bool = false
        var selectedImage: UIImage? = nil
        
        var isSavable: Bool {
            return nicknameInput.isEmpty == false && (
            accountInfo.nickname != nicknameInput ||
            dummyDescription != descriptionInput ||
            selectedImage != nil)
        }

        
        init(accountInfo: AccountInfo) {
            self.accountInfo = accountInfo
            self.nicknameInput = accountInfo.nickname ?? ""
            self.descriptionInput = accountInfo.description ?? ""
            self.dummyDescription = accountInfo.description ?? ""
        }
    }
    
    enum Action: Equatable {
        case changedDescriptionInput(String)
        case changedNicknameInput(String)
        case didTappedDismissButton
        case didTappedSaveButton
        case editAccountInfoResponse(TaskResult<EditAccountModelResponse>)
        case moveSignIn
        case selectProfileImage(UIImage)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .changedDescriptionInput(let description):
                if description.count <= 50 {
                    state.descriptionInput = description
                }
                return .none
                
            case .changedNicknameInput(let nickname):
                state.nicknameInput = nickname
                return .none
                
            case .didTappedDismissButton:
                return .run { send in
                    await dismiss()
                }
                
            case .didTappedSaveButton:
                guard state.isSavable == true,
                      state.isBusyAPI == false else { return .none }
                state.isBusyAPI = true
                return .none
                
            case .editAccountInfoResponse(.success(let response)):
                if response.success == true {
                    return .send(.moveSignIn)
                }
                return .none
                
            case .editAccountInfoResponse(.failure(let error)):
                debugPrint(error)
                return .none
                
            case .moveSignIn:
                resetAccountInfo()
                return .none
                
            case .selectProfileImage(let image):
                state.selectedImage = image
                return .none
            }
            
            func resetAccountInfo() {
                Utility.delete(key: Constant.token)
                Utility.delete(key: Constant.refreshToken)
                Utility.delete(key: Constant.loginPlatform)
                Utility.delete(key: Constant.profileImage)
            }
        }
    }
}
