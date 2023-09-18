//
//  FollowingUserListView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct FollowingUserListView: View {
    typealias FollowItem = FollowListModelResponse.DataModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: FollowingUserListViewModel = FollowingUserListViewModel()
    @State private var selectedIndex: Int = 0
    
    private let store: StoreOf<FollowingUserListFeature>
    @ObservedObject var viewStore: ViewStoreOf<FollowingUserListFeature>
    
    init(store: StoreOf<FollowingUserListFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                LazyVStack(spacing: 0.0) {
                    topCategoriesView(items: ["팔로워", "팔로잉"], selectedIndex: $selectedIndex)
                    followNFollowingListView
                }
            }
            
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.getFollowList()
            viewModel.getFollowerList()
        }
    }
}

extension FollowingUserListView {
    private var navigationBar: some View {
        HStack(spacing: 10.0) {
            Image("arrow_back")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var followNFollowingListView: some View {
        LazyVStack(spacing: 0.0) {
            if selectedIndex == 0 {
                followerListView
            } else if selectedIndex == 1 {
                followingListView
            }
        }
    }
    
    private var followerListView: some View {
        LazyVStack(spacing: 0.0) {
            ForEach(0..<viewModel.followerList.count, id: \.self) { index in
                NavigationLink(destination: {
                    FollowUserView(socialId: viewModel.followerList[index].member?.socialId ?? "",
                    memberId: viewModel.followerList[index].member?.memberId ?? 0)
                }, label: {
                    profileItem(item: viewModel.followerList[index], index: index)
                })
            }
        }
    }
    
    private var followingListView: some View {
        LazyVStack(spacing: 0.0) {
            ForEach(0..<viewModel.followList.count, id: \.self) { index in
                NavigationLink(destination: {
                    FollowUserView(socialId: viewModel.followList[index].member?.socialId ?? "",
                    memberId: viewModel.followList[index].member?.memberId ?? 0)
                }, label: {
                    profileItem(item: viewModel.followList[index], index: index)
                })
            }
        }
    }
    
    private func topCategoriesView(items: [String], selectedIndex: Binding<Int>) -> some View {
        HStack(spacing: 0.0) {
            ForEach(0..<items.count, id: \.self) {index in
                VStack(spacing: 0.0) {
                    Text(items[index])
                        .font(.pretendard(.medium, size: 14.0))
                        .foregroundColor(selectedIndex.wrappedValue == index ? .black : .gray_999999)
                        .frame(maxWidth:  .infinity,
                               maxHeight: .infinity,
                               alignment: .center)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedIndex.wrappedValue = index
                        }
                    if selectedIndex.wrappedValue == index {
                        Color.gray_404040
                            .frame(maxWidth: .infinity)
                            .frame(height: 1.0)
                    } else {
                        Color.gray_EDEDED
                            .frame(maxWidth: .infinity)
                            .frame(height: 1.0)
                    }
                }
            }
        }
        .frame(height: 40.0)
        .frame(maxWidth: .infinity)
    }
    
    
    
    private func profileItem(item: FollowItem, index: Int) -> some View {
        HStack(alignment: .center, spacing: 0.0) {
            KFImage(URL(string: item.member?.profileImgUrl ?? ""))
                .placeholder {
                    Image(uiImage: UIImage(named: "profile24") ?? UIImage())
                        .resizable()
                        .frame(width: 40.0,
                               height: 40.0)
                }
                .resizable()
                .frame(width: 40.0,
                       height: 40.0)
                .cornerRadius(.infinity)
            VStack(spacing: 3.0) {
                Text(item.member?.nickname ?? "-")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                HStack(spacing: 7.0) {
                    Text("팔로워 \(item.followerCount ?? 0)")
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 12.0))
                    Color.black
                        .frame(width: 1.0,
                               height: 11.0)
                    Text("팔로잉 \(item.followingCount ?? 0)")
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 12.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    
                }
            }
            .padding(.leading)
            Text(item.followStatus == "FOLLOWING" ? "팔로잉" : "팔로우")
                .foregroundColor(item.followStatus == "FOLLOWING" ? .blue_4708FA : .white)
                .font(.pretendard(.reguler, size: 12.0))
                .frame(width: 62.0,
                       height: 20.0,
                       alignment: .center)
                .background(item.followStatus == "FOLLOWING" ? Color.white : Color.blue_4708FA)
                .overlay(
                    RoundedRectangle(cornerRadius: 4.0)
                        .stroke(Color.blue_4708FA, lineWidth: 1.0)
                )
                .cornerRadius(4.0)
                .onTapGesture {
//                    isFollowing.toggle()
                    if selectedIndex == 0 {
                        viewModel.followerList[index].followStatus = viewModel.followerList[index].followStatus == "FOLLOWING" ? "FOLLOWER" : "FOLLOWING"
                    } else {
                        viewModel.followList[index].followStatus = viewModel.followList[index].followStatus == "FOLLOWING" ? "FOLLOWER" : "FOLLOWING"
                    }
                    viewModel.follow(memberId: item.member?.memberId ?? 0)
                }
            
               
        }
        .frame(height: 76.0)
        .padding(.horizontal, 16.0)
    }
}

struct FollowingUserListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingUserListView(store: Store(initialState: FollowingUserListFeature.State(), reducer: { FollowingUserListFeature() }))
    }
}
