//
//  HomeView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/13.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @State private var availableWidth: CGFloat = 10
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                LazyVStack(spacing: 40.0) {
                    hotCourseSectionView
                    userTasteCourseSectionView
                }
            }
        }
    }
}

extension HomeView {
    private var navigationBar: some View {
        HStack(spacing: 0.0) {
            Image("small_logo")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            NavigationLink(destination: {
                CourseSearchView()
            }, label: {
                Image("search24")
            })
            .padding(.trailing, 11.0)
            NavigationLink(destination: {
                MyPageView()
            }, label: {
                Image("profile24")
            })
        }
        .frame(height: 50.0)
        .padding(.horizontal, 16.0)
    }
    
    private var hotCourseSectionView: some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                Text("내 주변 코스")
                    .font(.pretendard(.bold, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("my_location")
                    .padding(4.0)
                Text("서울 종로구")
                    .font(.pretendard(.reguler, size: 12.0))
            }
            .padding(.horizontal, 16.0)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8.0) {
                    ForEach(0..<5) { index in
                        NavigationLink(destination: {
                            CourseDetailView()
                        }, label: {
                            hotCourseSectionItem(image: nil, title: "따듯한 3월에 가기 좋은 삼정동", course: "전시코스")
                                .cornerRadius(4.0)
                        })
                        
                    }
                }
            }
            .padding(.leading, 16.0)
            .padding(.top, 16.0)
        }
    }
    
    private func hotCourseSectionItem(image url: URL?, title: String, course: String) -> some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(url)
                .resizable()
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                
            VStack(spacing: 8.0) {
                Text(title)
                    .font(.pretendard(.bold, size: 15.0))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Text(course)
                    .font(.pretendard(.bold, size: 15.0))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
            }
            .padding(.horizontal, 16.0)
            .padding(.bottom, 16.0)
        }
        .frame(width: 242.0,
               height: 131.0)
        .cornerRadius(4.0)
        .background(Color.blue)
        
    }
    
    private var userTasteCourseSectionView: some View {
        LazyVStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                Text("내 취향 코스")
                    .font(.pretendard(.bold, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Text("취향 설정하기")
                    .font(.pretendard(.reguler, size: 12.0))
                    .padding(4.0)
                Image("chevron-right")
                    
            }
            .padding(.bottom, 10.0)
            Text("설정한 취향태그에 맞는 코스만 모았어요 :)")
                .font(.pretendard(.reguler, size: 12.0))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.bottom, 10.0)
            
            ForEach(0..<4) { index in
                userTasteCourseItem(image: nil, title: "그라운드시소 전시 데이트 ", isScrapped: index % 2 == 0, locationInfo: "서울 종로구", userTagList: ["1", "2", "3", "4"])
            }
        }
        .padding(.horizontal, 16.0)
    }
    
    private func userTasteCourseItem(image url: URL?, title: String, isScrapped: Bool, locationInfo: String, userTagList: [String]) -> some View {
        VStack(alignment: .leading, spacing: 0.0) {
            KFImage(url)
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 186.0)
                .background(
                    RoundedCorners(color: .gray_EDEDED,
                                   tl: 0.0, tr: 0.0 ,bl: 0.0, br: 0.0)
                )
            VStack(alignment: .leading, spacing: 0.0) {
                HStack(spacing: 0.0) {
                    Text(title)
                        .foregroundColor(.black)
                        .font(.pretendard(.bold, size: 16.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    Image(isScrapped ? "love" : "love_selected")
                }
                Text(locationInfo)
                    .font(.pretendard(.reguler, size: 12.0))
                    .foregroundColor(.gray_404040)
                Color.clear
                    .frame(height: 1.0)
                    .readSize { size in
                        availableWidth = size.width
                    }
                TagListView(availableWidth: availableWidth,
                            data: userTagList,
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
