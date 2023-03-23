//
//  AccountSettingView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/01.
//

import SwiftUI
import Kingfisher

struct AccountSettingView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: AccountSettingViewModel = AccountSettingViewModel()
    @State private var nickName: String = ""
    @State private var introduceInfo: String = ""
    @State private var isShowThumbnailPhotoPicker: Bool = false
    @State private var showPopup: Bool = false
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                VStack(spacing: 0.0) {
                    profilImageView
//                    userKeyView
                    customTextField(info: $nickName)
                    introduceTextEditorView
                }
                .padding(.horizontal, 16.0)
                .onTapGesture {
                    hideKeyboard()
                }
            }
            saveButton
                .padding(.horizontal, 16.0)
            secessionButton
                .padding(.horizontal, 16.0)
        }
        .navigationBarHidden(true)
        .onLoaded {
            viewModel.getmyAccountInfo {
                nickName = viewModel.accountInfo.nickname ?? ""
                introduceInfo = viewModel.accountInfo.description ?? ""
            }
        }
        .modifier(BasePopupModifier(isShowFlag: $showPopup, detailViewAlertType: .withdrawal,
                                            complete: {
            viewModel.withdrawal {
                let window = UIApplication
                            .shared
                            .connectedScenes
                            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                            .first { $0.isKeyWindow }

                        window?.rootViewController = UIHostingController(rootView: IntroView()
                            .environmentObject(mainViewModel))
                        window?.makeKeyAndVisible()
            }
        }))
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $isShowThumbnailPhotoPicker,
               content: {
            PhotoPicker(isPresented: $isShowThumbnailPhotoPicker, filter: .images, limit: 1) { result in
                PhotoPicker.convertToUIImageArray(fromResults: result) { (imagesOrNil, errorOrNil) in
                    if let images = imagesOrNil {
                        if let first = images.first {
                            viewModel.profileImage = first
                        }
                    }
                }
            }
        })
        
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
            if viewModel.profileImage == nil {
                KFImage(URL(string: viewModel.accountInfo.profileImgUrl ?? ""))
                    .placeholder {
                        Image(uiImage: UIImage(named: "profile56") ?? UIImage())
                            .resizable()
                            .frame(width: 100.0,
                                   height: 100.0)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100.0,
                           height: 100.0)
                    .cornerRadius(.infinity)
            } else {
                Image(uiImage: viewModel.profileImage ?? UIImage())
                    .resizable()
                    .frame(width: 100.0,
                           height: 100.0)
                    .cornerRadius(.infinity)
            }
            Image("add_circle")
        }
        .padding(.vertical, 36.0)
        .onTapGesture {
            isShowThumbnailPhotoPicker = true
        }
    }
    
    private var userKeyView: some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                Text("")
                    .font(.pretendard(.reguler, size: 16.0))
                    .foregroundColor(.gray_999999)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image(viewModel.accountInfo.social == "APPLE"
                      ? "appleComponent"
                      : "kakaoComponent")
                .padding(.trailing, 4.0)
                Text(viewModel.accountInfo.social ?? "")
                    .font(.pretendard(.reguler, size: 14.0))
                    .foregroundColor(.black)
            }
//            Color(UIColor.gray_D3D4D5)
//                .frame(height: 1.0)
        }
        .padding(.bottom, 45.0)
    }
    
    private func customTextField(info: Binding<String>) -> some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                TextField("", text: info)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image(viewModel.accountInfo.social == "APPLE"
                      ? "appleComponent"
                      : "kakaoComponent")
                .padding(.trailing, 4.0)
                Text(viewModel.accountInfo.social ?? "")
                    .font(.pretendard(.reguler, size: 14.0))
                    .foregroundColor(.black)
            }
            .padding(.bottom, 4.0)
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
        .frame(maxHeight: .infinity,
               alignment: .top)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            guard isEditable else { return }
            viewModel.changeMyInfo(nickname: nickName,
                                   description: introduceInfo,
                                   complete: {
                viewModel.getmyAccountInfo {
                    nickName = viewModel.accountInfo.nickname ?? ""
                    introduceInfo = viewModel.accountInfo.description ?? ""
                }
            })
        }, label: {
            Text("변경사항 저장하기")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48.0)
                .background(isEditable ? Color.blue_4708FA : Color.gray_D3D4D5)
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
                showPopup = true
            }
        
    }
    
    private var isEditable: Bool {
        return nickName.isEmpty == false &&
        viewModel.accountInfo.nickname != nickName ||
        viewModel.accountInfo.description != introduceInfo ||
        viewModel.profileImage != nil
    }
}

struct AccountSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingView()
    }
}
