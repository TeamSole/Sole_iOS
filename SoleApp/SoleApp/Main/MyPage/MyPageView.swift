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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: MyPageViewModel = MyPageViewModel()
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
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var profileView: some View {
        VStack(spacing: 0.0) {
            HStack(alignment: .center, spacing: 0.0) {
                KFImage(nil)
                    .placeholder {
                        Image(uiImage: UIImage(named: "profile56") ?? UIImage())
                            .resizable()
                            .frame(width: 56.0,
                                   height: 56.0)
                    }
                    .frame(width: 40.0,
                           height: 40.0)
                VStack(spacing: 3.0) {
                    HStack() {
                        Text("닉네임")
                            .foregroundColor(.black)
                            .font(.pretendard(.reguler, size: 14.0))
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                    }
                    HStack(spacing: 7.0) {
                        Text("팔로워")
                            .foregroundColor(.black)
                            .font(.pretendard(.reguler, size: 12.0))
                        Color.black
                            .frame(width: 1.0,
                                   height: 11.0)
                        Text("팔로잉")
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
                    .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            Text("로그아웃")
                .font(.pretendard(.reguler, size: 12.0))
                .underline()
                .foregroundColor(.gray_999999)
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
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
