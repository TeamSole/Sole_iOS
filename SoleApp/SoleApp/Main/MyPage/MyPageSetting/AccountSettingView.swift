//
//  AccountSettingView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/01.
//

import SwiftUI
import Kingfisher
import Combine
import ComposableArchitecture

struct AccountSettingView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @StateObject var viewModel: AccountSettingViewModel = AccountSettingViewModel()
    
    @State private var nickName: String = ""
    @State private var introduceInfo: String = ""
    @State private var isShowThumbnailPhotoPicker: Bool = false
    @State private var showPopup: Bool = false
    
    private let store: StoreOf<AccountSettingFeature>
    @ObservedObject var viewStore: ViewStoreOf<AccountSettingFeature>
    
    init(store: StoreOf<AccountSettingFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                VStack(spacing: 0.0) {
                    profilImageView
//                    userKeyView
                    customTextField()
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
        .modifier(BasePopupModifier(isShowFlag: $showPopup, detailViewAlertType: .withdrawal,
                                            complete: {
            viewModel.withdrawal {
                let window = UIApplication
                            .shared
                            .connectedScenes
                            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                            .first { $0.isKeyWindow }

                        window?.rootViewController = UIHostingController(rootView: AppView(store: Store(initialState: AppFeature.State(), reducer: { AppFeature() }))
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
                            viewStore.send(.selectProfileImage(first))
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
                    viewStore.send(.didTappedDismissButton)
                }
            Text(StringConstant.myPage)
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
                KFImage(URL(string: viewStore.accountInfo.profileImgUrl ?? ""))
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
                Image(viewStore.accountInfo.social == "APPLE"
                      ? "appleComponent"
                      : "kakaoComponent")
                .padding(.trailing, 4.0)
                Text(viewModel.accountInfo.social ?? "")
                    .font(.pretendard(.reguler, size: 14.0))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity,
                   alignment: .trailing)
//            Color(UIColor.gray_D3D4D5)
//                .frame(height: 1.0)
        }
        .padding(.bottom, 45.0)
    }
    
    private func customTextField() -> some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                TextField("", text: viewStore.binding(get: \.nicknameInput,
                                                      send: AccountSettingFeature.Action.changedNicknameInput))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image(viewStore.accountInfo.social == "APPLE"
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
            Text(StringConstant.introduceShortComment)
                .font(Font(UIFont.pretendardMedium(size: 14.0)))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.bottom, 8.0)
            TextEditor(text: viewStore.binding(get: \.descriptionInput,
                                               send: AccountSettingFeature.Action.changedDescriptionInput))
                .frame(height: 84.0)
                .cornerRadius(4.0)
                .border(Color(UIColor.gray_D3D4D5), width: 1.0)
//                .onReceive(Just(introduceInfo)) { _ in limitText(50) }
            Text(String(format: "%d/50", viewStore.descriptionInput.count))
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
            viewStore.send(.didTappedSaveButton)
//            guard isEditable else { return }
//            viewModel.changeMyInfo(nickname: nickName,
//                                   description: introduceInfo,
//                                   complete: {
//                viewModel.getmyAccountInfo {
//                    nickName = viewModel.accountInfo.nickname ?? ""
//                    introduceInfo = viewModel.accountInfo.description ?? ""
//                }
//            })
        }, label: {
            Text(StringConstant.saveChangedInfo)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48.0)
                .background(viewStore.isSavable ? Color.blue_4708FA : Color.gray_D3D4D5)
                .cornerRadius(8.0)
        })
        .padding(.bottom, 28.0)
    }
    
    private var secessionButton: some View {
        Text(StringConstant.withdrawl)
            .foregroundColor(Color(UIColor.gray_999999))
            .font(Font(UIFont.pretendardRegular(size: 12.0)))
            .underline()
            .padding(.bottom, 28.0)
            .onTapGesture {
                showPopup = true
            }
        
    }
    
    func limitText(_ upper: Int) {
        if introduceInfo.count > upper {
            introduceInfo = String(introduceInfo.prefix(upper))
        }
    }
}

struct AccountSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingView(store: Store(initialState: AccountSettingFeature.State(accountInfo: .init()), reducer: { AccountSettingFeature() }))
    }
}
