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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: ScrapListViewModel = ScrapListViewModel()
    @State private var isEditMode: Bool = false
    @State private var showBottomPopup: Bool = false
    @State private var showPopup: Bool = false
    @State private var showMoveScrapPopup: Bool = false
    @State private var popupType: FolderPopupType = .rename
    @State private var selectedScraps: [Int] = []
    
    var folderId: Int
    @State private var folderName: String
    
    
    init(folderId: Int, folderName: String) {
        self.folderId = folderId
        self._folderName = State(initialValue: folderName)
    }

    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                LazyVStack(spacing: 0.0) {
                    if viewModel.apiRequestStatus == false &&
                        viewModel.scraps.isEmpty {
                        emptyResultView
                    } else {
                        listHeaderView
                        scrapList
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.getScraps(isDefaultFolder: isDefaultFolder, folderId: folderId)
        }
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
        .modifier(MoveScrapsPopupModifier(isShowFlag: $showMoveScrapPopup, scraps: selectedScraps,
                                          complete: { moveToFolderId in
            selectedScraps = []
            isEditMode = false
        }))
    }
}

extension ScrapListView {
    private var navigationBar: some View {
        HStack {
            Image("arrow_back")
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text(folderName)
                .foregroundColor(.black)
                .font(.pretendard(.medium, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .center)
            if isEditMode {
                Text("완료")
                    .foregroundColor(.blue_4708FA)
                    .font(.pretendard(.medium, size: 14.0))
                    .onTapGesture {
                        isEditMode = false
                        selectedScraps = []
                    }
            } else {
                Image("more-vertical")
                    .isHidden(isDefaultFolder)
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
            if isEditMode {
                Text("이동")
                    .font(.pretendard(.medium, size: 12.0))
                    .foregroundColor(.black)

                    .frame(width: 60.0,
                           height: 24.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12.0)
                            .stroke(selectedScraps.isEmpty ? Color.gray_D3D4D5 : Color.blue_4708FA,
                                    lineWidth: 1.0)
                    )
                    .isHidden(isDefaultFolder == false, remove: true)
                    .onTapGesture {
                        guard selectedScraps.isEmpty == false else { return }
                        showMoveScrapPopup = true
                    }
                Text("삭제")
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
                        guard selectedScraps.isEmpty == false else { return }
                        popupType = .removeScrap
                        showPopup = true
                    }
                
            } else {
                HStack(spacing: 2.0) {
                    Image("edit")
                    Text("편집")
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
                    isEditMode = true
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
            ForEach(0..<viewModel.scraps.count, id: \.self) { index in
                NavigationLink(destination: {
                    CourseDetailView(store: Store(initialState: CourseDetailFeature.State(courseId: viewModel.scraps[index].courseId ?? 0), reducer: { CourseDetailFeature()}))
                }, label: {
                    scrapItem(item: viewModel.scraps[index], index: index)
                })
            }
        }
        .padding(.horizontal, 16.0)
    }
    
    private func scrapItem(item: Scrap, index: Int) -> some View {
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
                    if isEditMode {
                        Image(selectedScraps.contains(item.courseId ?? 0) ? "check_circle" : "radio_button_unchecked")
                            .onTapGesture {
                                if selectedScraps.contains(item.courseId ?? 0) {
                                    selectedScraps = selectedScraps.filter({ $0 != item.courseId })
                                } else {
                                    selectedScraps.append(item.courseId ?? 0)
                                }
                            }
                    }
                }
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
            Text("아직 스크랩한 장소가 없습니다.")
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .padding(.top, 100.0)
    }
    
    private var isDefaultFolder: Bool {
        return folderName == "기본 폴더"
    }
    
    private func popupComplete(foldername: String) {
        if popupType == .remove {
            viewModel.removeFolder(folderId: folderId,
                                   complete: {
                presentationMode.wrappedValue.dismiss()
            })
        } else if popupType == .rename {
            viewModel.renameFolder(folderId: folderId,
                                   folderName: foldername,
                                   complete: {
                folderName = foldername
            })
        } else {
            viewModel.removeScraps(isDefaultFolder: isDefaultFolder,
                                   folderId: folderId,
                                   scraps: selectedScraps,
                                   complete: {
                selectedScraps = []
                isEditMode = false
            })
        }
    }
}

struct ScrapListView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapListView(folderId: 0, folderName: "폴더명")
    }
}
