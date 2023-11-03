//
//  CourseSearchView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/13.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct CourseSearchView: View {
    typealias Course = CourseModelResponse.DataModel
//    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    @State private var searchText: String = ""
    @State private var availableWidth: CGFloat = 10
    
    private let store: StoreOf<CourseSearchFeature>
    @ObservedObject var viewStore: ViewStoreOf<CourseSearchFeature>
    
    init(store: StoreOf<CourseSearchFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                VStack(spacing: 0.0) {
                    if viewStore.title.isEmpty {
                        searchResultListView
                    } else {
                        emptyResultView(title: viewStore.title)
                    }
                }
            }
            navigationToCourseDetailView
            
        }
        .navigationBarHidden(true)
    }
}

extension CourseSearchView {
    private var navigationBar: some View {
        HStack(spacing: 14.0) {
            Image("arrow_back")
                .onTapGesture {
                    viewStore.send(.didTappedDismissButton)
                }
            HStack(spacing: 5.0) {
                Image(systemName: "magnifyingglass")
                TextField(StringConstant.search, text: $searchText, onEditingChanged: { isEditing in
                    if viewStore.searchText.isEmpty == false {
                        viewStore.send(.clearSearchText)
                    }
                }, onCommit: {
                    viewStore.send(.searchCourse(searchText: searchText))
                })
                .frame(maxWidth: .infinity)
            }
            .padding(7.0)
            .background(Color.gray_EDEDED)
            .cornerRadius(10.0)
//            Text("취소")
//                .foregroundColor(.gray_404040)
//                .font(.pretendard(.reguler, size: 14.0))
                
        }
        .padding(.horizontal, 16.0)
        .frame(height: 50.0)
    }
    private var searchResultListView: some View {
        LazyVStack(spacing: 0.0) {
            ForEach(0..<viewStore.courses.count, id: \.self) { index in
                userTasteCourseItem(item: viewStore.courses[index], index: index)
                    .onTapGesture {
                        viewStore.send(.didTappedCourseDetail(courseId: viewStore.courses[index].courseId ?? 0))
                    }
//                NavigationLinkStore(self.store.scope(state: \.$courseDetail, action: CourseSearchFeature.Action.courseDetail),
//                                    onTap: { viewStore.send(.didTappedCourseDetail(courseId: viewStore.courses[index].courseId ?? 0)) },
//                                    destination: { CourseDetailView(store: $0) },
//                                    label: { userTasteCourseItem(item: viewStore.courses[index], index: index) })
            }
        }
    }
    
    private func userTasteCourseItem(item: Course, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0.0) {
            KFImage(URL(string: item.thumbnailImg ?? ""))
                .resizable()
                .scaledToFill()
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
                            viewStore.send(.scrap(courseId: item.courseId ?? 0))
                        }
                }
                Text("\(item.address ?? "") · \(item.computedDuration) · \(item.scaledDistance) \(StringConstant.move)")
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
        .padding(.horizontal, 16.0)
    }
    
    
    private var searchItemListView: some View {
        LazyVStack(spacing: 16.0) {
            HStack(spacing: 0.0) {
                Text(StringConstant.recentSearchHistory)
                    .font(.pretendard(.bold, size: 14.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Text(StringConstant.removeAll)
                    .font(.pretendard(.bold, size: 12.0))
                    .foregroundColor(.blue_0996F6)
                
            }
            ForEach(0..<4) { index in
                searchHistoryItem(title: "\(index)")
            }
        }
        .frame(maxHeight: .infinity,
               alignment: .top)
        .padding(.horizontal, 16.0)
        .padding(.top, 28.0)
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
    
    private func searchHistoryItem(title: String) -> some View {
        HStack(spacing: 0.0) {
            Text(title)
                .font(.pretendard(.reguler, size: 14.0))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            Image("close")
        }
        
    }
    
    private var addNextPageButton: some View {
        HStack(spacing: 0.0) {
            if viewStore.isCalledApi == true {
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
            viewStore.send(.searchCourseNextPage)
        }
        .isHidden(viewStore.courses.last?.finalPage == true, remove: true)
    }
    
    private var navigationToCourseDetailView: some View {
        NavigationLinkStore(self.store.scope(state: \.$courseDetail, action:  CourseSearchFeature.Action.courseDetail),
                            onTap: {},
                            destination: {
            CourseDetailView(store: $0)
        }, label: {
            EmptyView()
        })
    }
}

struct CourseSearchView_Previews: PreviewProvider {
    static var previews: some View {
        CourseSearchView(store: Store(initialState: CourseSearchFeature.State(), reducer: { CourseSearchFeature() }))
    }
}
