//
//  FollowUserView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct FollowUserView: View {
    typealias Course = FollowUserModelResponse.Place
    @State private var availableWidth: CGFloat = 10
    
    private let store: StoreOf<FollowUserFeature>
    @ObservedObject var viewStore: ViewStoreOf<FollowUserFeature>
    
    init(store: StoreOf<FollowUserFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                profileSectionView
                introduceView
                thickSectionDivider
                popularCourseView
                recentCourseView
            }
        }
        .navigationBarHidden(true)
        .onLoaded {
            viewStore.send(.viewDidLoad)
        }
    }
}

extension FollowUserView {
    private var navigationBar: some View {
        HStack(spacing: 10.0) {
            Image("arrow_back")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .onTapGesture {
                    viewStore.send(.didTappedDismissButton)
                }
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var profileSectionView: some View {
        HStack(alignment: .center, spacing: 0.0) {
            KFImage(URL(string: viewStore.userDetail.profileImg ?? ""))
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
                Text(viewStore.userDetail.nickname ?? "")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                HStack(spacing: 7.0) {
                    Text("\(StringConstant.follower) \(viewStore.userDetail.followerCount ?? 0)")
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 12.0))
                    Color.black
                        .frame(width: 1.0,
                               height: 11.0)
                    Text("\(StringConstant.following) \(viewStore.userDetail.followingCount ?? 0)")
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 12.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    
                }
            }
            .padding(.leading)
            Text(viewStore.userDetail.isFollowing ? StringConstant.following : StringConstant.follow)
                .foregroundColor(viewStore.userDetail.isFollowing ? .blue_4708FA : .white)
                .font(.pretendard(.reguler, size: 12.0))
                .frame(width: 62.0,
                       height: 20.0,
                       alignment: .center)
                .background(viewStore.userDetail.isFollowing ? Color.white : Color.blue_4708FA)
                .cornerRadius(4.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 4.0)
                        .stroke(Color.blue_4708FA, lineWidth: 1.0)
                )
                .onTapGesture {
                    viewStore.send(.follow)
                }
        }
        .frame(height: 76.0)
        .padding(.horizontal, 16.0)
    }
    
    private var introduceView: some View {
        Text(viewStore.userDetail.description ?? "")
            .foregroundColor(.black)
            .font(.pretendard(.reguler, size: 14.0))
            .frame(maxWidth: .infinity,
                   alignment: .leading)
            .padding(.horizontal, 16.0)
            .padding(.bottom, 16.0)
    }
    
    private var thickSectionDivider: some View {
        Color.gray_EDEDED
            .frame(height: 3.0)
            .frame(maxWidth: .infinity)
    }
    
    private var popularCourseView: some View {
        VStack(spacing: 12.0) {
            Text(String(format: "%@\(StringConstant.onesPopulateCourse)", viewStore.userDetail.nickname ?? ""))
                .foregroundColor(.black)
                .font(.pretendard(.bold, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            if viewStore.popularCourse == nil {
                emptyResultView(title: StringConstant.emptyCoursePopulate)
            } else {
                courseItem(item: viewStore.popularCourse ?? Course(), index: -1)
            }
        }
        .padding(16.0)
    }
    
    private var recentCourseView: some View {
        LazyVStack(spacing: 12.0) {
            Text(String(format: "%@\(StringConstant.onesRecentCourse)", viewStore.userDetail.nickname ?? ""))
                .foregroundColor(.black)
                .font(.pretendard(.bold, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            if viewStore.recentCourses?.isEmpty == true {
                emptyResultView(title: StringConstant.emptyCourseRegistered)
            } else {
                ForEach(0..<(viewStore.recentCourses?.count ?? 0), id: \.self) { index in
                    NavigationLinkStore(self.store.scope(state: \.$courseDetail, action: FollowUserFeature.Action.courseDetail),
                                        onTap: { viewStore.send(.didTappedCourseDetail(courseId: viewStore.recentCourses?[index].courseId ?? 0))
                    }, destination: { CourseDetailView(store: $0) },
                                        label: {
                        courseItem(item: viewStore.recentCourses?[index] ?? Course(), index: index)
                    })
                }
                addNextPageButton
            }
        }
        .padding(16.0)
    }
    
    private func courseItem(item: Course, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0.0) {
            KFImage(URL(string: item.thumbnailImg ?? ""))
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 186.0)
                .scaledToFill()
                .background(
                    RoundedCorners(color: .gray_EDEDED,
                                   tl: 0.0, tr: 0.0 ,bl: 0.0, br: 0.0)
                )
            VStack(alignment: .leading, spacing: 4.0) {
                HStack(spacing: 0.0) {
                    Text(item.title ?? "")
                        .foregroundColor(.black)
                        .font(.pretendard(.bold, size: 16.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    Image(item.isScrapped ? "love_selected" : "love")
                        .onTapGesture {
                            
                            viewStore.send(.scrap(couseId: item.courseId))
                        }
                }
                Text("\(item.address ?? "") · \(item.computedDuration) · \(item.scaledDistance) 이동")
                    .font(.pretendard(.reguler, size: 12.0))
                    .foregroundColor(.gray_404040)
                    .padding(.vertical, 2.0)
                Color.clear
                    .frame(height: 1.0)
                    .readSize { size in
                        availableWidth = size.width
                    }
                TagListView(availableWidth: availableWidth,
                            data: item.cateogoryTitles,
                            spacing: 8.0,
                            alignment: .leading,
                            isExpandedUserTagListView: .constant(false),
                            maxRows: .constant(0)) { item in
                    HStack(spacing: 0.0) {
                        Text(item)
                            .foregroundColor(.black)
                            .font(.pretendard(.reguler, size: 11.0))
                            .frame(height: 18.0)
                            .padding(.horizontal, 8.0)
                            .background(Color.gray_EDEDED)
                            .cornerRadius(4.0)
                    }
                    
                }
            }
            .padding(16.0)
        }
        .border(Color.gray_EDEDED, width:  1.0)
        .cornerRadius(12.0)
        .padding(.vertical, 10.0)
    }
    
    private func emptyResultView(title: String) -> some View {
        VStack(spacing: 17.0) {
            Image("emptyResult")
            Text(title)
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .padding(.vertical, 40.0)
    }
    
    private var addNextPageButton: some View {
        HStack(spacing: 0.0) {
            if viewStore.isCalledApi {
                ProgressView()
            } else {
                Text(StringConstant.moreWithPlus)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40.0)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.gray_D3D4D5, lineWidth: 1.0)
        )
        .padding(.vertical, 16.0)
        .contentShape(Rectangle())
        .onTapGesture {
            viewStore.send(.getNextUserDetail)
        }
        .isHidden(viewStore.recentCourses?.last?.finalPage == true, remove: true)
    }

}

struct FollowUserView_Previews: PreviewProvider {
    static var previews: some View {
        FollowUserView(store: Store(initialState: FollowUserFeature.State(socialId: "", memberId: 0), reducer: { FollowUserFeature() }))
    }
}
