//
//  HomeView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/13.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    typealias Course = CourseModelResponse.DataModel
    @EnvironmentObject var mainViewModel: MainViewModel
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @State private var availableWidth: CGFloat = 10
    @State private var isShowSelectTagView: Bool = false
    @State private var isShowFirstSelectTagView: Bool = false
    
    var body: some View {
        ZStack() {
            VStack(spacing: 0.0) {
                navigationBar
                ScrollView {
                    LazyVStack(spacing: 40.0) {
                        bannerView
                        hotCourseSectionView
                        userTasteCourseSectionView
                    }
                }
            }
            floatingButton
        }
        .onLoaded {
            viewModel.locationManager.requestLocation()
            viewModel.getRecommendCourses()
            viewModel.getCourses()
        }
        .onAppear {
            if mainViewModel.isFirstSignUp == true {
                isShowFirstSelectTagView = true
            }
        }
        .fullScreenCover(isPresented: $isShowFirstSelectTagView,
                         content: {
            SelectTagView(selectType: .first, complete: { place, with, trans in
                viewModel.setTaste(place: place, with: with, tras: trans)
            })
                .onDisappear {
                    mainViewModel.isFirstSignUp = false
                }
        })
        .sheet(isPresented: $isShowSelectTagView,
               content: {
            SelectTagView(selectType: .add, complete: {place, with, trans in
                viewModel.setTaste(place: place, with: with, tras: trans)})
        })
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
                    .environmentObject(mainViewModel)
            }, label: {
                if Utility.load(key: Constant.profileImage).isEmpty {
                    Image("profile24")
                } else {
                    KFImage(URL(string: Utility.load(key: Constant.profileImage)))
                        .placeholder {
                            Image(uiImage: UIImage(named: "profile24") ?? UIImage())
                        }
                        .resizable()
                        .frame(width: 24.0,
                               height: 24.0)
                        .cornerRadius(.infinity)
                }
                
            })
        }
        .frame(height: 50.0)
        .padding(.horizontal, 16.0)
    }
    
    private var bannerView: some View {
        VStack(spacing: 0.0) {
            Image("banner")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
//                .frame(height: 150.0)
        }
    }
    
    private var hotCourseSectionView: some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                Text("내 주변 인기 코스")
                    .font(.pretendard(.bold, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                HStack(spacing: 0.0) {
                    Image("my_location")
                        .padding(4.0)
                    Text(viewModel.location.address ?? "서울 마포구")
                        .font(.pretendard(.reguler, size: 12.0))
                }
                .onTapGesture {
                    viewModel.locationManager.requestLocation()
                    
                }
            }
            .padding(.horizontal, 16.0)
            if viewModel.recommendCourses.isEmpty {
                emptyRecommendResultView
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8.0) {
                        ForEach(0..<viewModel.recommendCourses.count, id: \.self) { index in
                            NavigationLink(destination: {
                                CourseDetailView(courseId: viewModel.recommendCourses[index].courseId ?? 0, isScrapped: true)
                            }, label: {
                                hotCourseSectionItem(image: URL(string: viewModel.recommendCourses[index].thumbnailImg ?? ""),
                                                     title: viewModel.recommendCourses[index].courseName ?? "")
                                .cornerRadius(4.0)
                            })
                        }
                    }
                }
                .padding(.leading, 16.0)
                .padding(.top, 16.0)
            }
                
        }
    }
    
    private func hotCourseSectionItem(image url: URL?, title: String) -> some View {
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
                HStack(spacing: 4.0) {
                    Text("취향 설정하기")
                        .font(.pretendard(.reguler, size: 12.0))
                    Image("chevron-right")
                }
                .onTapGesture {
                    isShowSelectTagView = true
                }
                    
            }
            .padding(.bottom, 10.0)
            if viewModel.courses.isEmpty {
                emptyTasteView
            } else {
                Text("설정한 취향태그에 맞는 코스만 모았어요 :)")
                    .font(.pretendard(.reguler, size: 12.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.bottom, 10.0)
                
                ForEach(0..<viewModel.courses.count, id: \.self) { index in
                    NavigationLink(destination: {
                        CourseDetailView(courseId: viewModel.courses[index].courseId ?? 0,
                                         isScrapped: viewModel.courses[index].isScrapped)
                    }, label: {
                        userTasteCourseItem(item: viewModel.courses[index], index: index)
                    })
                    
                }
            }
        }
        .padding(.horizontal, 16.0)
    }
    
    private func userTasteCourseItem(item: Course, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0.0) {
            KFImage(URL(string: item.thumbnailImg ?? ""))
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 186.0)
                .cornerRadius(4.0)
                .background(
                    RoundedCorners(color: .gray_EDEDED,
                                   tl: 0.0, tr: 0.0 ,bl: 0.0, br: 0.0)
                )
            VStack(alignment: .leading, spacing: 0.0) {
                HStack(spacing: 0.0) {
                    Text(item.title ?? "")
                        .foregroundColor(.black)
                        .font(.pretendard(.bold, size: 16.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    Image(item.isScrapped ? "love_selected" : "love" )
                        .onTapGesture {
                            viewModel.courses[index].like?.toggle()
                            viewModel.scrap(courseId: item.courseId ?? 0)
                        }
                }
                Text("\(item.address ?? "")·\(item.computedDuration)·\(item.scaledDistance) 이동")
                    .font(.pretendard(.reguler, size: 12.0))
                    .foregroundColor(.gray_404040)
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
    
    private var floatingButton: some View {
        GeometryReader {geo in
            HStack(alignment: .bottom, spacing: 0.0) {
                Spacer()
                VStack(alignment: .trailing, spacing: 0.0) {
                    Spacer()
                    NavigationLink(destination: {
                        RegisterCouseView()
                    }, label: {
                        HStack(spacing: 0.0) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 15.0,
                                       height: 15.0)
                        }
                        .frame(width: 48.0,
                               height: 48.0)
                        .foregroundColor(.white)
                        .background(Circle()
                            .fill(Color.blue_4708FA)
                            .cornerRadius(.infinity))
                    })
                   
//                    .onTapGesture {
//
//                    }
                }
                .padding(.trailing, 16.0)
                .padding(.bottom, 16.0)
            }
        }
    }
    
    private var emptyRecommendResultView: some View {
        VStack(spacing: 17.0) {
            Image("emptyRecommendResult")
            Text("이 지역에 등록된 장소가 없습니다.")
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .padding(.vertical, 50.0)
    }
    
    private var emptyTasteView: some View {
        VStack(spacing: 17.0) {
            Image("emptyTasteResult")
            Text("설정한 취향 태그가 없습니다.")
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .padding(.vertical, 50.0)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(MainViewModel())
    }
}
