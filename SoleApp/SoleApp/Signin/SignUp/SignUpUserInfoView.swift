//
//  SignUpUserInfoView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/16.
//

import SwiftUI

struct SignUpUserInfoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var nickName: String = ""
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            profileImageView
            nickNameTextFieldView
            continueButton
        }
        .navigationBarHidden(true)
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
            Image("profile56")
                .resizable()
                .frame(width: 120.0,
                       height: 120.0)
            Image("add_circle")
                .padding(.horizontal, 7.0)
                .padding(.bottom, 7.0)
        }
        .padding(.top, 63.0)
    }
    
    private var nickNameTextFieldView: some View {
        VStack(spacing: 0.0) {
            HStack() {
                TextField("닉네임을 입력해주세요. (최대 10자)", text: $nickName)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("24px_valid")
            }
            Color.gray_D3D4D5
                .frame(height: 1.0)
            Text("")
                .foregroundColor(.black)
                .font(.pretendard(.reguler, size: 13.0))
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
            .background(Color.blue_4708FA)
            .cornerRadius(8.0)
            .padding(.horizontal, 16.0)
            .padding(.bottom, 40.0)
    }
}

struct SignUpUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpUserInfoView()
    }
}
