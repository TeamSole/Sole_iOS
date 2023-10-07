//
//  ScrapListView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct ScrapListView: View {
    typealias Scrap = ScrapListModelResponse.DataModel
//    @StateObject var viewModel: ScrapListViewModel = ScrapListViewModel()
//    @State private var isEditMode: Bool = false
    @State private var showBottomPopup: Bool = false
    @State private var showPopup: Bool = false
    @State private var showMoveScrapPopup: Bool = false
    @State private var popupType: FolderPopupType = .rename
    @State private var selectedScraps: [Int] = []
    
    var folderId: Int = 0
    @State private var folderName: String = ""
    
    private let store: StoreOf<ScrapListFeature>
    @ObservedObject var viewStore: ViewStoreOf<ScrapListFeature>
    
    init(store: StoreOf<ScrapListFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }

    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                LazyVStack(spacing: 0.0) {
                    if viewStore.isCalledApi == false &&
                        viewStore.scrapList.isEmpty {
                        emptyResultView
                    } else {
                        listHeaderView
                        scrapList
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onLoaded {
            viewStore.send(.viewDidLoad)
        }
        // TODO: modifier alert나 popup으로 바꾸기
        .modifier(BottomSheetModifier(showFlag: $showBottomPopup,
                                      edit: {
            popupType = .rename
            showPopup = true
        },
                                      remove:  {
            popupType = .remove
            showPopup = true
        }))
        .modifier(FolderPopupTextFieldModifier(isShowFlag: $showPopup,
                                               folderPopupType: popupType,
                                               complete: { foldername in
            popupComplete(foldername: foldername)
        }))
        .modifier(MoveScrapsPopupModifier(isShowFlag: $showMoveScrapPopup, scraps: viewStore.selectedScrapsCourseId,
                                          complete: { moveToFolderId in
            selectedScraps = []
            viewStore.send(.setEditMode(isEditMode: false))
        }))
    }
}

extension ScrapListView {
    private var navigationBar: some View {
        HStack {
            Image("arrow_back")
                .onTapGesture {
                    viewStore.send(.didTappedDismissButton)
                }
            Text(viewStore.folderName)
                .foregroundColor(.black)
                .font(.pretendard(.medium, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .center)
            if viewStore.isEditMode {
                Text(StringConstant.complete)
                    .foregroundColor(.blue_4708FA)
                    .font(.pretendard(.medium, size: 14.0))
                    .onTapGesture {
                        viewStore.send(.setEditMode(isEditMode: false))
//                        selectedScraps = []
                    }
            } else {
                Image("more-vertical")
                    .isHidden(viewStore.isDefaultFolder)
                    .onTapGesture {
                        showBottomPopup = true
                    }
            }
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var listHeaderView: some View {
        HStack(spacing: 8.0) {
            if viewStore.isEditMode {
                Text(StringConstant.move)
                    .font(.pretendard(.medium, size: 12.0))
                    .foregroundColor(.black)
                    .frame(width: 60.0,
                           height: 24.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12.0)
                            .stroke(selectedScraps.isEmpty ? Color.gray_D3D4D5 : Color.blue_4708FA,
                                    lineWidth: 1.0)
                    )
                    .isHidden(viewStore.isDefaultFolder == false, remove: true)
                    .onTapGesture {
                        guard viewStore.selectedScrapsCourseId.isEmpty == false else { return }
                        showMoveScrapPopup = true
                    }
                Text(StringConstant.delete)
                    .font(.pretendard(.medium, size: 12.0))
                    .foregroundColor(.black)
                    .frame(width: 60.0,
                           height: 24.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12.0)
                            .stroke(selectedScraps.isEmpty ? Color.gray_D3D4D5 : Color.blue_4708FA,
                                    lineWidth: 1.0)
                    )
                    .onTapGesture {
                        guard viewStore.selectedScrapsCourseId.isEmpty == false else { return }
                        popupType = .removeScrap
                        showPopup = true
                    }
                
            } else {
                HStack(spacing: 2.0) {
                    Image("edit")
                    Text(StringConstant.edit)
                        .font(.pretendard(.medium, size: 12.0))
                        .foregroundColor(.black)
                }
                .frame(width: 60.0,
                       height: 24.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 12.0)
                        .stroke(Color.gray_D3D4D5, lineWidth: 1.0)
                )
                .onTapGesture {
                    viewStore.send(.setEditMode(isEditMode: true))
                }
            }
        }
        .frame(maxWidth: .infinity,
               alignment: .trailing)
        .padding(.horizontal, 16.0)
        .padding(.vertical, 5.0)
    }
    
    private var scrapList: some View {
        VStack(spacing: 20.0) {
            ForEach(viewStore.scrapList, id: \.courseId) { item in
                NavigationLink(destination: {
                    CourseDetailView(store: Store(initialState: CourseDetailFeature.State(courseId: item.courseId ?? 0), reducer: { CourseDetailFeature() }))
                }, label: {
                    scrapItem(item: item)
                })
//                NavigationLinkStore(self.store.scope(state: \.$courseDetail, action: ScrapListFeature.Action.courseDetail),
//                                    onTap: { viewStore.send(.didTappedCourseDetail(courseId: item.courseId ?? 0)) },
//                                    destination: { CourseDetailView(store: $0) },
//                                    label: { scrapItem(item: item) })
            }
        }
        .padding(.horizontal, 16.0)
    }
    
    private func scrapItem(item: Scrap) -> some View {
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
            VStack(spacing: 0.0) {
                HStack(spacing: 0.0) {
                    Text(item.title ?? "")
                        .font(.pretendard(.bold, size: 14.0))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .padding(.bottom, 7.0)
                    if viewStore.isEditMode {
                        Image(viewStore.selectedScrapsCourseId.contains(item.courseId ?? 0) ? "check_circle" : "radio_button_unchecked")
                            .onTapGesture {
                                guard let courseId = item.courseId else { return }
                                viewStore.send(.toggleSelectScrap(courseId: courseId))
                            }
                    }
                }
                Text(String(format: "%@ · %@ · %@ \(StringConstant.move)", item.address ?? "", item.computedDuration, item.scaledDistance))
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
            Text(StringConstant.emptyCourseScrapped)
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .padding(.top, 100.0)
    }
    
    private func popupComplete(foldername: String) {
        if popupType == .remove {
            viewStore.send(.removeFolder)
        } else if popupType == .rename {
            viewStore.send(.renameFolder(folderName: foldername))
        } else {
            viewStore.send(.removeScraps)
        }
    }
}

struct ScrapListView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapListView(store: Store(initialState: ScrapListFeature.State(folderId: 0, folderName: ""), reducer: { ScrapListFeature() }))
    }
}
