//
//  AccountSettingView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/01.
//

import SwiftUI

struct AccountSettingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var nickName: String = "너구리"
    @State private var introduceInfo: String = "ㅎㅎ"
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            VStack(spacing: 0.0) {
                profilImageView
                customTextField(info: $nickName)
                introduceTextEditorView
                Spacer()
                saveButton
                secessionButton
            }
            .padding(.horizontal, 16.0)
        }
    }
}

extension AccountSettingView {
    private var navigationBar: some View {
        ZStack {
            Image("arrow_back")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("마이페이지")
                .foregroundColor(.black)
                .font(.pretendard(.medium, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .center)
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var profilImageView: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("profile56")
                .resizable()
                .frame(width: 100.0,
                       height: 100.0)
            Image("add_circle")
        }
        .padding(.vertical, 36.0)
    }
    
    private func customTextField(info: Binding<String>) -> some View {
        VStack(spacing: 0.0) {
            TextField("", text: info)
                .padding(.bottom, 2.0)
            Color(UIColor.gray_D3D4D5)
                .frame(height: 1.0)
        }
        .padding(.bottom, 45.0)
    }
    
    private var introduceTextEditorView: some View {
        VStack(spacing: 0.0) {
            Text("한 줄 소개")
                .font(Font(UIFont.pretendardMedium(size: 14.0)))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.bottom, 8.0)
            TextEditor(text: $introduceInfo)
                .frame(height: 84.0)
                .cornerRadius(4.0)
                .border(Color(UIColor.gray_D3D4D5), width: 1.0)
            Text(String(format: "%d/50", introduceInfo.count))
                .font(Font(UIFont.pretendardRegular(size: 10.0)))
                .foregroundColor(Color(UIColor.gray_D3D4D5))
                .frame(maxWidth: .infinity,
                       alignment: .trailing)
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            // TODO: action 추가하기
        }, label: {
            Text("변경사항 저장하기")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48.0)
                .background(Color(UIColor.blue_4708FA))
                .cornerRadius(8.0)
        })
        .padding(.bottom, 28.0)
    }
    
    private var secessionButton: some View {
        Text("탈퇴하기")
            .foregroundColor(Color(UIColor.gray_999999))
            .font(Font(UIFont.pretendardRegular(size: 12.0)))
            .underline()
            .padding(.bottom, 28.0)
            .onTapGesture {
                // TODO: 탈퇴하기 기능 추가
            }
        
    }
}

struct AccountSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingView()
    }
}
