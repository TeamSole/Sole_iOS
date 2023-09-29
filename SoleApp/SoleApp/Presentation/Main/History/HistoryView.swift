//
//  HistoryView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/12.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct HistoryView: View {
    typealias History = HistoryModelResponse.DataModel
    
    @State private var isShowSelectTagView: Bool = false
    
    private let filterType: [String] = [StringConstant.place, StringConstant.accompony, StringConstant.vehicles]
    private let store: StoreOf<HistoryFeature>
    @ObservedObject var viewStore: ViewStoreOf<HistoryFeature>
    
    init(store: StoreOf<HistoryFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        ZStack() {
            VStack(spacing: 0.0) {
                naviagationBar
                ScrollView {
                    LazyVStack(spacing: 0.0) {
                        profileSectionView
                        thickSectionDivider
                        courseHistoryListView
                    }
                }
            }
            floatingButton
        }
        .onLoaded {
            viewStore.send(.viewDidLoad)
        }
        .sheet(isPresented: $isShowSelectTagView,
               content: {
            SelectTagView(selectedPlace: viewStore.selectedPlaceParameter,
                          selectedWith: viewStore.selectedWithParameter,
                          selectedTrans: viewStore.selectedVehiclesParameter,
                          selectType: .filter,
                          complete: {place, with, trans in
                viewStore.send(.setHistoryParameter(places: place, with: with, vehicles: trans))
            })
        })
    }
}

extension HistoryView {
    private var naviagationBar: some View {
        HStack(spacing: 0.0) {
            Text(StringConstant.myHistory)
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(height: 48.0)
    }
    
    private var profileSectionView: some View {
        HStack(alignment: .top, spacing: 0.0) {
            KFImage(URL(string: Utility.load(key: Constant.profileImage)))
                .placeholder {
                    Image(uiImage: UIImage(named: "profile56") ?? UIImage())
                        .resizable()
                        .frame(width: 56.0,
                               height: 56.0)
                }
                .resizable()
                .frame(width: 56.0,
                       height: 56.0)
                .scaledToFill()
                .cornerRadius(.infinity)
            VStack(spacing: 0.0) {
                Text("\(viewStore.userHistoryDescription.nickname ?? "-")님의 발자국")
                    .foregroundColor(.black)
                    .font(.pretendard(.bold, size: 16.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                HStack(spacing: 0.0) {
                    Text("지금까지 ")
                        .font(.pretendard(.reguler, size: 14.0))
                        .foregroundColor(.black)
                    + Text("\(viewStore.userHistoryDescription.totalDate ?? 0)")
                        .font(.pretendard(.reguler, size: 14.0))
                        .foregroundColor(.blue_4708FA)
                    + Text("일간 ")
                        .font(.pretendard(.reguler, size: 14.0))
                        .foregroundColor(.black)
                    + Text("\(viewStore.userHistoryDescription.totalPlaces ?? 0)")
                        .font(.pretendard(.reguler, size: 14.0))
                        .foregroundColor(.blue_4708FA)
                    + Text("곳의 장소를 방문하며, ")
                        .font(.pretendard(.reguler, size: 14.0))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.top, 16.0)
                HStack(spacing: 0.0) {
                    Text("이번달 총 ")
                        .font(.pretendard(.reguler, size: 14.0))
                        .foregroundColor(.black)
                    + Text("\(viewStore.userHistoryDescription.totalCourses ?? 0)")
                        .font(.pretendard(.reguler, size: 14.0))
                        .foregroundColor(.blue_4708FA)
                    + Text("개의 코스를 기록했어요.")
                        .font(.pretendard(.reguler, size: 14.0))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.bottom, 16.0)
                    
            }
            .frame(maxWidth: .infinity,
                   alignment: .topLeading)
            .padding(.leading)
               
        }
        .padding(16.0)
    }
    
    private var thickSectionDivider: some View {
        Color.gray_EDEDED
            .frame(height: 3.0)
            .frame(maxWidth: .infinity)
    }
    
    private var courseHistoryHeader: some View {
        VStack(spacing: 12.0) {
            Text(StringConstant.registeredCourse)
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            HStack(spacing: 8.0) {
                ForEach(0..<filterType.count, id: \.self) { index in
                    HStack(spacing: 4.0){
                        Text(filterType[index])
                            .foregroundColor(.black)
                            .font(.pretendard(.reguler, size: 12.0))
                        Image("chevron.forward")
                    }
                    .padding(.horizontal, 12.0)
                    .padding(.vertical, 5.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4.0)
                            .stroke(Color.gray_D3D4D5, lineWidth: 1.0)
                    )
                    .onTapGesture {
                        isShowSelectTagView = true
                    }
                    
                }
            }
            .frame(maxWidth: .infinity,
                   alignment: .leading)
        }
    }
    
    private var courseHistoryListView: some View {
        LazyVStack(spacing: 20.0) {
            courseHistoryHeader
            if viewStore.isCalledApi == false &&
                viewStore.userHistories.isEmpty {
                emptyResultView
            } else {
                ForEach(viewStore.userHistories, id: \.courseId) { item in
                    NavigationLinkStore(self.store.scope(state: \.$courseDetail, action: HistoryFeature.Action.courseDetail),
                                        onTap: { viewStore.send(.didTappedCourseDetail(courseId: item.courseId ?? 0))
                    }, destination: { CourseDetailView(store: $0) },
                                        label: {
                        courseHistoryItem(item: item)
                    })
                }
                addNextPageButton
            }
        }
        .padding(16.0)
    }
    
    private func courseHistoryItem(item: History) -> some View {
        HStack(alignment: .top, spacing: 15.0) {
            KFImage(URL(string: item.thumbnailImg ?? ""))
                .placeholder {
                    Image(uiImage: UIImage(named: "profile56") ?? UIImage())
                        .resizable()
                        .frame(width: 100.0,
                               height: 100.0)
                }
                .resizable()
                .frame(width: 100.0,
                       height: 100.0)
                .scaledToFill()
            VStack(spacing: 0.0) {
                Text(item.title ?? "")
                    .font(.pretendard(.bold, size: 14.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.bottom, 7.0)
                Text("\(item.address ?? "") · \(item.computedDuration) · \(item.scaledDistance) 이동")
                    .font(.pretendard(.reguler, size: 12.0))
                    .foregroundColor(.gray_999999)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.bottom, 7.0)
                HStack(spacing: 8.0) {
                    ForEach(0..<item.cateogoryTitles.count, id: \.self) { index in
                        Text(item.cateogoryTitles[index])
                            .font(.pretendard(.reguler, size: 9.0))
                            .foregroundColor(.black)
                            .padding(6.0)
                            .background(Color.gray_EDEDED)
                            .cornerRadius(3.0)
                    }
                }
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            }
            
        }
    }
    
    private var emptyResultView: some View {
        VStack(spacing: 17.0) {
            Image("emptyResult")
            Text(StringConstant.emptyCourseAdded)
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .padding(.top, 100.0)
    }
    
    private var floatingButton: some View {
        GeometryReader {geo in
            HStack(alignment: .bottom, spacing: 0.0) {
                Spacer()
                VStack(alignment: .trailing, spacing: 0.0) {
                    Spacer()
                    NavigationLinkStore(self.store.scope(state: \.$registerCourse, action: HistoryFeature.Action.registerCourse),
                                        onTap: { viewStore.send(.didTappedFloatingButton) },
                                        destination: { RegisterCouseView(store: $0) },
                                        label: {
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
                            .cornerRadius(.infinity)) })
                }
                .padding(.trailing, 16.0)
                .padding(.bottom, 16.0)
            }
        }
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
            viewStore.send(.getNextUserHistories)
        }
        .isHidden(viewStore.userHistories.last?.finalPage == true, remove: true)
    }
    
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(store: Store(initialState: HistoryFeature.State(), reducer: { HistoryFeature() }))
    }
}
