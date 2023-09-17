//
//  FollowingBoardView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/08.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct FollowingBoardView: View {
//    typealias CourseOfFollower = FollowBoardModelResponse.DataModel
    typealias CourseOfFollower = FollowBoardModelResponse.DataModel
    @StateObject var viewModel: FollowingBoardViewModel = FollowingBoardViewModel()
    
    private let store: StoreOf<FollowBoardFeature>
    @ObservedObject var viewStore: ViewStoreOf<FollowBoardFeature>
    
    init(store: StoreOf<FollowBoardFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
            VStack(spacing: 0.0) {
                navigationView
                ScrollView {
                    if viewStore.isCalledApi == false &&
                        viewStore.courses.isEmpty {
                        emptyResultView
                    } else {
                        VStack(spacing: 16.0) {
                            ForEach(viewStore.courses, id: \.courseId) { item in
                                // TODO: NavigationLinkStore 연결해야함
                                NavigationLink(destination: {
                                    CourseDetailView(store: Store(initialState: CourseDetailFeature.State(courseId: item.courseId ?? 0), reducer: { CourseDetailFeature()}))
                                }, label: {
                                    courseListItem(item: item)
                                })
                            }
                        }
                    } 
                }
            }
            .frame(maxHeight: .infinity)
            .navigationBarHidden(true)
            .onLoaded() {
                viewStore.send(.viewDidLoad)
            }
    }
}

extension FollowingBoardView {
    private var navigationView: some View {
        ZStack(alignment: .trailing) {
            Text(StringConstant.following)
                .foregroundColor(.black)
                .font(Font(UIFont.pretendardBold(size: 16.0)))
                .frame(maxWidth: .infinity,
                       alignment: .center)
            NavigationLink(destination: {
                FollowingUserListView()
            }, label: {
                Image("people_alt")
            })
            .padding(.trailing, 15.0)
        }
        .frame(height: 46.0)
    }
    
    private func courseListItem(item: CourseOfFollower) -> some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                KFImage(URL(string: item.profileImg ?? ""))
                    .resizable()
                    .placeholder {
                        Image(uiImage: UIImage(named: "profile24") ?? UIImage())
                            .resizable()
                            .frame(width: 32.0,
                                   height: 32.0)
                    }
                    .scaledToFill()
                    .frame(width: 32.0,
                           height: 32.0)
                    .cornerRadius(.infinity)
                    .padding(.trailing, 8.0)
                Text(item.nickname ?? "")
                    .font(Font(UIFont.pretendardRegular(size: 14.0)))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image(item.like == true ? "love_selected" : "love")
                    .onTapGesture {
                        guard let courseId = item.courseId else { return }
                        viewStore.send(.scrap(couseId: courseId))
                    }
            }
            .padding(.horizontal, 3.0)
            .frame(height: 52.0)
            
            VStack(spacing: 0.0) {
                KFImage(URL(string: item.thumbnailImg ?? ""))
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 186.0)
                    .scaledToFit()
                    .padding(.bottom, 10.0)
                Text(item.title ?? "")
                    .font(Font(UIFont.pretendardBold(size: 16.0)))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.bottom, 4.0)
                Text(item.description ?? "")
                    .font(Font(UIFont.pretendardRegular(size: 13.0)))
                    .lineSpacing(4.0)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .lineLimit(nil)
                
            }
            .frame(maxWidth: .infinity,
                   alignment: .leading)
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding(.horizontal, 16.0)
    }
    
    private var emptyResultView: some View {
        VStack(spacing: 17.0) {
            Image("emptyResult")
            Text(StringConstant.emptyCourseFollowed)
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .padding(.top, 100.0)
    }
    
}

struct FollowingBoardView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingBoardView(store: Store(initialState: FollowBoardFeature.State(), reducer: { FollowBoardFeature() }))
    }
}
