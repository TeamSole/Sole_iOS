//
//  FollowUserView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/20.
//

import SwiftUI
import Kingfisher

struct FollowUserView: View {
    typealias Course = FollowUserModelResponse.Place
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: FollowUserViewModel = FollowUserViewModel()
    @State private var availableWidth: CGFloat = 10
    var socialId: String
    var memberId: Int
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
        .onAppear{
            viewModel.getUserDetail(socialId: socialId)
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
                    presentationMode.wrappedValue.dismiss()
                }
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var profileSectionView: some View {
        HStack(alignment: .center, spacing: 0.0) {
            KFImage(URL(string: viewModel.userDetail.profileImg ?? ""))
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
                Text(viewModel.userDetail.nickname ?? "")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                HStack(spacing: 7.0) {
                    Text("팔로워 \(viewModel.userDetail.followerCount ?? 0)")
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 12.0))
                    Color.black
                        .frame(width: 1.0,
                               height: 11.0)
                    Text("팔로잉 \(viewModel.userDetail.followingCount ?? 0)")
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 12.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    
                }
            }
            .padding(.leading)
            Text(viewModel.userDetail.isFollowing ? "팔로잉" : "팔로우")
                .foregroundColor(viewModel.userDetail.isFollowing ? .blue_4708FA : .white)
                .font(.pretendard(.reguler, size: 12.0))
                .frame(width: 62.0,
                       height: 20.0,
                       alignment: .center)
                .background(viewModel.userDetail.isFollowing ? Color.white : Color.blue_4708FA)
                .cornerRadius(4.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 4.0)
                        .stroke(Color.blue_4708FA, lineWidth: 1.0)
                )
                .onTapGesture {
                    if viewModel.userDetail.isFollowing {
                        viewModel.userDetail.followStatus = "FOLLOWER"
                    } else {
                        viewModel.userDetail.followStatus = "FOLLOWING"
                    }
                    viewModel.follow(memberId: memberId)
                }
        }
        .frame(height: 76.0)
        .padding(.horizontal, 16.0)
    }
    
    private var introduceView: some View {
        Text(viewModel.userDetail.description ?? "")
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
            Text(String(format: "%@의 인기 코스", viewModel.userDetail.nickname ?? ""))
                .foregroundColor(.black)
                .font(.pretendard(.bold, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            if viewModel.popularCourse == nil {
                emptyResultView(title: "아직 인기 코스가 없습니다.")
            } else {
                courseItem(item: viewModel.popularCourse ?? Course(), index: -1)
            }
        }
        .padding(16.0)
    }
    
    private var recentCourseView: some View {
        LazyVStack(spacing: 12.0) {
            Text(String(format: "%@의 최근 코스", viewModel.userDetail.nickname ?? ""))
                .foregroundColor(.black)
                .font(.pretendard(.bold, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            if viewModel.recentCourses?.isEmpty == true {
                emptyResultView(title: "아직 등록한 코스가 없습니다.")
            } else {
                ForEach(0..<(viewModel.recentCourses?.count ?? 0), id: \.self) { index in
                    NavigationLink(destination: {
                        CourseDetailView(courseId: viewModel.recentCourses?[index].courseId ?? 0, isScrapped: viewModel.recentCourses?[index].isScrapped ?? false)
                    }, label: {
                        courseItem(item: viewModel.recentCourses?[index] ?? Course(), index: index)
                    })
                    
                }
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
                            if index == -1 {
                                viewModel.popularCourse?.like?.toggle()
                                viewModel.scrap(courseId: viewModel.popularCourse?.courseId ?? 0)
                            } else {
                                viewModel.recentCourses?[index].like?.toggle()
                                viewModel.scrap(courseId: viewModel.recentCourses?[index].courseId ?? 0)
                            }
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

}

struct FollowUserView_Previews: PreviewProvider {
    static var previews: some View {
        FollowUserView(socialId: "", memberId: 0)
    }
}
