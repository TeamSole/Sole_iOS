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
        var selectedImage: UIImage? = nil
        
        init(accountInfo: AccountInfo) {
            self.accountInfo = accountInfo
        }
    }
    
    enum Action: Equatable {
        case didTappedDismissButton
        case selectProfileImage(UIImage)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTappedDismissButton:
                return .run { send in
                    await dismiss()
                }
                
            case .selectProfileImage(let image):
                state.selectedImage = image
                return .none
            }
        }
    }
}
