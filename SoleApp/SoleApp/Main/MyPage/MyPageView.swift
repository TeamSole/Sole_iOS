//
//  MyPageView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Kingfisher
import Introspect

struct MyPageView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: MyPageViewModel = MyPageViewModel()
    @State private var showPopup: Bool = false
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
        .onLoaded {
            viewModel.getmyAccountInfo()
        }
        .modifier(BasePopupModifier(isShowFlag: $showPopup, detailViewAlertType: .logout,
                                            complete: {
            viewModel.logout {
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
        
    }
}

extension MyPageView {
    private var navigationBar: some View {
        HStack {
            Image("arrow_back")
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("마이페이지")
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
                KFImage(URL(string: viewModel.accountInfo.profileImgUrl ?? ""))
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
                        Text(viewModel.accountInfo.nickname ?? "-")
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
                        Text(String(format: "팔로워 %d",
                                    viewModel.accountInfo.follower ?? 0))
                            .foregroundColor(.black)
                            .font(.pretendard(.reguler, size: 12.0))
                        Color.black
                            .frame(width: 1.0,
                                   height: 11.0)
                        Text(String(format: "팔로잉 %d",
                                    viewModel.accountInfo.following ?? 0))
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
            List(viewModel.myPageViewCellData, id: \.self) { item in
                menuItem(leftTitle: item.leftTitle, rightTitle: item.rightTitle)
                    .onTapGesture {
                        if item == .terms {
                            UIApplication.shared.open(URL(string: "https://team-sole.notion.site/64e1f0366c8a4f65ac0a3040776594b3")!)
                        } else if item == .privacyPolicy {
                            UIApplication.shared.open(URL(string: "https://team-sole.notion.site/8c353f0248ef4b838797863738c7b458")!)
                        }
                    }
                    .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            Text("로그아웃")
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
        MyPageView()
    }
}
