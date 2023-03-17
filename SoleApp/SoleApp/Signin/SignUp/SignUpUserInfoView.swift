//
//  SignUpUserInfoView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/16.
//

import SwiftUI

struct SignUpUserInfoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: SignUpViewModel
    @State private var nickName: String = ""
    @State private var showPhotoPicker: Bool = false
    @State private var showSignUpCompleteView: Bool = false

   
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            profileImageView
            nickNameTextFieldView
            continueButton
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
                            viewModel.selectedImage = first
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
                    presentationMode.wrappedValue.dismiss()
                }
            Text("회원가입")
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
            if viewModel.selectedImage == nil {
                Image("profile56")
                    .resizable()
                    .frame(width: 120.0,
                           height: 120.0)
            } else {
                Image(uiImage: viewModel.selectedImage!)
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
                TextField("닉네임을 입력해주세요. (최대 10자)",
                          text: $nickName,
                          onEditingChanged: { isEditing in
                    if isEditing {
                        viewModel.isAvailableNickname = nil
                    }
                }, onCommit: {
                    viewModel.isValidNickName(name: nickName)
                })
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                Image(validImageName())
            }
            Color.gray_D3D4D5
                .frame(height: 1.0)
                .padding(.vertical, 8.0)
            Text(messageForNickName())
                .foregroundColor(viewModel.isAvailableNickname == true
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
        Text("시작하기")
            .foregroundColor(.white)
            .font(.pretendard(.medium, size: 16.0))
            .frame(maxWidth: .infinity,
                   alignment: .center)
            .frame(height: 48.0)
            .background(viewModel.isAvailableNickname == true
                        ? Color.blue_4708FA
                        : Color.gray_D3D4D5)
            .cornerRadius(8.0)
            .padding(.horizontal, 16.0)
            .padding(.bottom, 40.0)
            .contentShape(Rectangle())
            .onTapGesture {
                guard viewModel.isAvailableNickname == true else { return }
                viewModel.model.nickname = nickName
                viewModel.signUp {
                    showSignUpCompleteView = true
                }
                
            }
    }
    
    private var navigateToSignUpUserInfoView: some View {
        NavigationLink(destination:
                        SignUpCompleteView(viewModel: viewModel),
                       isActive: $showSignUpCompleteView,
                       label: {
            EmptyView()
        })
    }
}

extension SignUpUserInfoView {
    func messageForNickName() -> String {
        if viewModel.isAvailableNickname == nil {
            return ""
        } else if viewModel.isAvailableNickname == true {
            return "사용 가능한 닉네임입니다."
        } else if viewModel.isAvailableNickname == false && nickName.isEmpty {
            return "닉네임을 입력해 주세요."
        } else if viewModel.isAvailableNickname == false && nickName.count > 10 {
            return "닉네임은 최대 10자까지 작성이 가능해요."
        } else if viewModel.isAvailableNickname == false {
            return "이 닉네임은 이미 다른 사람이 사용하고 있어요."
        } else {
            return ""
        }
    }
    
    func validImageName() -> String {
        if viewModel.isAvailableNickname == true {
            return "24px_valid"
        } else if viewModel.isAvailableNickname == false {
            return "24px_invalid"
        } else {
            return ""
        }
    }
}

struct SignUpUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpUserInfoView(viewModel: .init())
    }
}
