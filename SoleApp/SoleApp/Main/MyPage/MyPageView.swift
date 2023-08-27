//
//  MyPageView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Kingfisher
import Introspect
import ComposableArchitecture

struct MyPageView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var showPopup: Bool = false
    
    private let store: StoreOf<MyPageFeature>
    @ObservedObject var viewStore: ViewStoreOf<MyPageFeature>
    
    init(store: StoreOf<MyPageFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            profileView
            menuList
        }
        .introspectTableView {
            $0.isScrollEnabled = false
        }
        .navigationBarHidden(true)
        .onAppear {
            viewStore.send(.viewWillAppear)
        }
        .modifier(BasePopupModifier(isShowFlag: $showPopup, detailViewAlertType: .logout,
                                            complete: {
            viewStore.send(.didTappedLogOutButton)
        }))
        
    }
}

extension MyPageView {
    private var navigationBar: some View {
        HStack {
            Image("arrow_back")
                .onTapGesture {
                    viewStore.send(.didTappedDismissButton)
                }
            Text(StringConstant.myPage)
                .foregroundColor(.black)
                .font(.pretendard(.medium, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .center)
            Image("bell")
                .isHidden(true)
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var profileView: some View {
        VStack(spacing: 0.0) {
            HStack(alignment: .center, spacing: 0.0) {
                KFImage(URL(string: viewStore.accountInfo.profileImgUrl ?? ""))
                    .placeholder {
                        Image(uiImage: UIImage(named: "profile56") ?? UIImage())
                            .resizable()
                            .frame(width: 56.0,
                                   height: 56.0)
                    }
                    .resizable()
                    .frame(width: 56.0,
                           height: 56.0)
                    .cornerRadius(.infinity)
                VStack(spacing: 3.0) {
                    HStack() {
                        Text(viewStore.accountInfo.nickname ?? "-")
                            .foregroundColor(.black)
                            .font(.pretendard(.reguler, size: 14.0))
                        NavigationLink(destination: {
                            AccountSettingView()
                                .environmentObject(mainViewModel)
                        }, label: {
                            Image("edit-circle")
                        })
                    }
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    HStack(spacing: 7.0) {
                        Text(String(format: "%@ %d",
                                    StringConstant.follower,
                                    viewStore.accountInfo.follower ?? 0))
                            .foregroundColor(.black)
                            .font(.pretendard(.reguler, size: 12.0))
                        Color.black
                            .frame(width: 1.0,
                                   height: 11.0)
                        Text(String(format: "%@ %d",
                                    StringConstant.following,
                                    viewStore.accountInfo.following ?? 0))
                            .foregroundColor(.black)
                            .font(.pretendard(.reguler, size: 12.0))
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                        
                    }
                }
                .padding(.leading)
            }
            .frame(height: 100.0)
            .padding(.horizontal, 16.0)
            Color.gray_EDEDED
                .frame(maxWidth: .infinity)
                .frame(height: 4.0)
        }
    }
    
    private var menuList: some View {
        VStack(spacing: 0.0) {
            List(viewStore.myPageViewCellData, id: \.self) { item in
                menuItem(leftTitle: item.leftTitle, rightTitle: item.rightTitle)
                    .onTapGesture {
                        if item == .terms {
                            Utility.openUrlWithSafari(url: K.getTermsUrl())
                        } else if item == .privacyPolicy {
                            Utility.openUrlWithSafari(url: K.getPrivacyPolicyUrl())
                        }
                    }
                    .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            Text(StringConstant.logOut)
                .font(.pretendard(.reguler, size: 12.0))
                .underline()
                .foregroundColor(.gray_999999)
                .padding(.bottom)
                .onTapGesture {
                    showPopup = true
                }
        }
    }
    
    private func menuItem(leftTitle: String, rightTitle: String) -> some View {
        HStack(spacing: 0.0) {
            Text(leftTitle)
                .font(.pretendard(.reguler, size: 16.0))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            Text(rightTitle)
                .font(.pretendard(.reguler, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(height: 53.0)
        .padding(.horizontal, 16.0)
        .contentShape(Rectangle())
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(store: Store(initialState: MyPageFeature.State(), reducer: { MyPageFeature() }))
    }
}
