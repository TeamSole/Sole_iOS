//
//  SignUpUserInfoFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/08/19.
//

import ComposableArchitecture
import UIKit

struct SignUpUserInfoFeature: Reducer {
    struct State: Equatable {
        var model: SignUpModel
        var nicknameInput: String = ""
        var nicknameValidMessage: String = ""
        var isAvailableNickname: Bool? = nil
        var isBusyAPI: Bool = false
        var selectedImage: UIImage? = nil
        @PresentationState var signUpComplete: SignUpCompleteFeature.State?
        var validImageName: String {
            if isAvailableNickname == true {
                return "24px_valid"
            } else if isAvailableNickname == false {
                return "24px_invalid"
            } else {
                return ""
            }
        }
        
        
        init(model: SignUpModel) {
            self.model = model
        }
    }
    
    enum Action: Equatable {
        case checkValidationForNicknameResponse(TaskResult<Bool>)
        case didTappedBackButton
        case didTappedContinueButton
        case didTappedDoneButton
        case nicknameInputChanged(String)
        case selectProfileImage(UIImage)
        case signUpComplete(PresentationAction<SignUpCompleteFeature.Action>)
        case signUpResponse(TaskResult<SignUpModelResponse>)
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.signUpClient) var signUpClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .checkValidationForNicknameResponse(.success(let isValid)):
                state.isBusyAPI = false
                state.isAvailableNickname = isValid
                messageForNickName()
                return .none
                
            case .checkValidationForNicknameResponse(.failure(let error)):
                state.isBusyAPI = false
                debugPrint(error)
                return .none
                
            case .didTappedBackButton:
                return .run(operation: { _ in await dismiss() })
                
            case .didTappedContinueButton:
                guard state.isAvailableNickname == true,
                      state.isBusyAPI == false else { return .none }
                state.isBusyAPI = true
                state.model.nickname = state.nicknameInput
                
                return .run { [model = state.model, image = state.selectedImage] send in
                    await send(.signUpResponse(
                        TaskResult {
                            try await signUpClient.signUp(model, image)
                        }
                    ))
                }
                
            case .didTappedDoneButton:
                guard state.nicknameInput.isEmpty == false else {
                    state.isAvailableNickname = false
                    messageForNickName()
                    return .none }
                
                guard  state.nicknameInput.count <= 10 else {
                    state.isAvailableNickname = false
                    messageForNickName()
                    return .none }
                return .run { [nickname = state.nicknameInput] send in
                    let parameter = CheckValidationForNicknameRequest(nickname: nickname)
                    await send(.checkValidationForNicknameResponse(
                        TaskResult {
                            try await signUpClient.checkValidationForNickname(parameter)
                        }
                    ))
                }
                
            case .nicknameInputChanged(let nickname):
                state.isAvailableNickname = nil
                state.nicknameInput = nickname
                return .none
                
            case .selectProfileImage(let image):
                state.selectedImage = image
                return .none
                
            case .signUpComplete:
                return .none
                
            case .signUpResponse(.success(let response)):
                if let imageUrl = response.data?.profileImgUrl {
                    Utility.save(key: Constant.profileImage, value: imageUrl)
                }
                if let token = response.data?.accessToken,
                   let refreshToken = response.data?.refreshToken {
                    Utility.save(key: Constant.token, value: token)
                    Utility.save(key: Constant.refreshToken, value: refreshToken)
                    Utility.save(key: Constant.loginPlatform, value: state.model.platform)
                    state.signUpComplete = SignUpCompleteFeature.State()
                }
                return .none
                
            case .signUpResponse(.failure(let error)):
                debugPrint(error.localizedDescription)
                return .none
            }
            
            
            func messageForNickName() {
                if state.isAvailableNickname == nil {
                    state.nicknameValidMessage = ""
                } else if state.isAvailableNickname == true {
                    state.nicknameValidMessage = StringConstant.usableNickname
                } else if state.isAvailableNickname == false && state.nicknameInput.isEmpty {
                    state.nicknameValidMessage = StringConstant.pleaseTypeNickname
                } else if state.isAvailableNickname == false && state.nicknameInput.count > 10 {
                    state.nicknameValidMessage = StringConstant.maxLength10ForNicknameInput
                } else if state.isAvailableNickname == false {
                    state.nicknameValidMessage = StringConstant.alreadyExistNickname
                } else {
                    state.nicknameValidMessage = ""
                }
            }
        }
        .ifLet(\.$signUpComplete, action: /Action.signUpComplete) {
            SignUpCompleteFeature()
        }
    }
}
