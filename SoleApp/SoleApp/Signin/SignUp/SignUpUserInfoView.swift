//
//  SignUpUserInfoView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/16.
//

import SwiftUI
import ComposableArchitecture

struct SignUpUserInfoView: View {
    @ObservedObject var viewModel: SignUpViewModel
    @State private var showPhotoPicker: Bool = false
    @State private var showSignUpCompleteView: Bool = false

    private let store: StoreOf<SignUpUserInfoFeature>
    @ObservedObject var viewStore: ViewStoreOf<SignUpUserInfoFeature>
    
    init(store: StoreOf<SignUpUserInfoFeature>) {
        self.viewModel = .init()
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
   
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            profileImageView
            nickNameTextFieldView
            continueButton
            navigateToSignUpSignUpCompleteView
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showPhotoPicker,
               content: {
            PhotoPicker(isPresented: $showPhotoPicker,
                        filter: .images,
                        limit: 1) { results in
                PhotoPicker.convertToUIImageArray(fromResults: results) { (imagesOrNil, errorOrNil) in
                    if let images = imagesOrNil {
                        if let first = images.first {
                            viewStore.send(.selectProfileImage(first))
                        }
                    }
                }
            }
        })
    }
}

extension SignUpUserInfoView {
    private var navigationBar: some View {
        ZStack {
            Image("arrow_back")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .onTapGesture {
                    viewStore.send(.didTappedBackButton)
                }
            Text(StringConstant.signUp)
                .foregroundColor(.black)
                .font(.pretendard(.medium, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .center)
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var profileImageView: some View {
        ZStack(alignment: .bottomTrailing) {
            if viewStore.selectedImage == nil {
                Image("profile56")
                    .resizable()
                    .frame(width: 120.0,
                           height: 120.0)
            } else {
                Image(uiImage: viewStore.selectedImage!)
                    .resizable()
                    .frame(width: 120.0,
                           height: 120.0)
                    .cornerRadius(60.0)
            }
            Image("add_circle")
                .padding(.horizontal, 7.0)
                .padding(.bottom, 7.0)
        }
        .padding(.top, 63.0)
        .onTapGesture {
            showPhotoPicker = true
        }
    }
    
    private var nickNameTextFieldView: some View {
        VStack(spacing: 0.0) {
            HStack() {
                TextField(StringConstant.pleasetypeNicknameMaxLength18,
                          text: viewStore.binding(get: \.nicknameInput,
                                                  send: SignUpUserInfoFeature.Action.nicknameInputChanged)
                , onCommit: {
                    viewStore.send(.didTappedDoneButton)
                })
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                Image(viewStore.validImageName)
            }
            Color.gray_D3D4D5
                .frame(height: 1.0)
                .padding(.vertical, 8.0)
            Text(viewStore.nicknameValidMessage)
                .foregroundColor(viewStore.isAvailableNickname == true
                                 ? .green_8BDEB5
                                 : .red_FF717D)
                .font(.pretendard(.reguler, size: 13.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            Spacer()
        }
        .padding(.top, 50.0)
        .padding(.horizontal, 16.0)
    }
    
    private var continueButton: some View {
        Text(StringConstant.start)
            .foregroundColor(.white)
            .font(.pretendard(.medium, size: 16.0))
            .frame(maxWidth: .infinity,
                   alignment: .center)
            .frame(height: 48.0)
            .background(viewStore.isAvailableNickname == true
                        ? Color.blue_4708FA
                        : Color.gray_D3D4D5)
            .cornerRadius(8.0)
            .padding(.horizontal, 16.0)
            .padding(.bottom, 40.0)
            .contentShape(Rectangle())
            .onTapGesture {
                guard viewModel.isAvailableNickname == true else { return }
                viewModel.signUp {
                    showSignUpCompleteView = true
                }
                
            }
    }
    
    private var navigateToSignUpSignUpCompleteView: some View {
        NavigationLink(destination:
                        SignUpCompleteView(store: Store(initialState: SignUpCompleteFeature.State(), reducer: { SignUpCompleteFeature() }))
            .environmentObject(AppDelegate.shared.mainViewModel),
                       isActive: $showSignUpCompleteView,
                       label: {
            EmptyView()
        })
        .isDetailLink(false)
    }
}

extension SignUpUserInfoView {
    
    
   
}

struct SignUpUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpUserInfoView(store: Store(initialState: SignUpUserInfoFeature.State(model: SignUpModel()),
                                          reducer: { SignUpUserInfoFeature() }))
    }
}
