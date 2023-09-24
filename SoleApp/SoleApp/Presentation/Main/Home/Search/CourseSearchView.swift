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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    @State private var searchText: String = ""
    @State private var title: String = ""
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
                    if viewModel.title.isEmpty {
                        searchResultListView
                    } else {
                        emptyResultView(title: viewModel.title)
                    }
                }
            }
            
        }
        .navigationBarHidden(true)
    }
}

extension CourseSearchView {
    private var navigationBar: some View {
        HStack(spacing: 14.0) {
            Image("arrow_back")
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            HStack(spacing: 5.0) {
                Image(systemName: "magnifyingglass")
                TextField("검색", text: $searchText, onEditingChanged: { isEditing in
                    viewModel.title = ""
                }, onCommit: {
                    guard searchText.isEmpty == false else {
                        viewModel.title = "검색어를 입력해 주세요."
                        return }
                    viewModel.getCourses(keyword: searchText)
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
            ForEach(0..<viewModel.courses.count, id: \.self) { index in
                NavigationLink(destination: {
                    CourseDetailView(store: Store(initialState: CourseDetailFeature.State(courseId: viewModel.courses[index].courseId ?? 0), reducer: { CourseDetailFeature()}))
                }, label: {
                    userTasteCourseItem(item: viewModel.courses[index], index: index)
                })
                
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
                            viewModel.courses[index].like?.toggle()
                            viewModel.scrap(courseId: item.courseId ?? 0)
                        }
                }
                Text("\(item.address ?? "") · \(item.computedDuration) · \(item.scaledDistance) 이동")
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
                Text("최근 검색")
                    .font(.pretendard(.bold, size: 14.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Text("전체 삭제")
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
            if viewModel.callingRequest {
                ProgressView()
            } else {
                Text("더보기 +")
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
            guard viewModel.callingRequest == false else { return }
            viewModel.getNextCourses(keyword: searchText)
        }
        .isHidden(viewModel.courses.last?.finalPage == true, remove: true)
    }
}

struct CourseSearchView_Previews: PreviewProvider {
    static var previews: some View {
        CourseSearchView(store: Store(initialState: CourseSearchFeature.State(), reducer: { CourseSearchFeature() }))
    }
}
