//
//  ScrapFolderView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct ScrapFolderView: View {
    @State private var showPopup: Bool = false
    private let gridItem: [GridItem] = [
        GridItem(.flexible(minimum: 100.0, maximum: (UIScreen.main.bounds.width - 48) / 2), spacing: 16.0),
        GridItem(.flexible(minimum: 100.0, maximum: (UIScreen.main.bounds.width - 48) / 2), spacing: 16.0)
    ]
    
    private let gridItemHeight: CGFloat = (UIScreen.main.bounds.width - 48) / 2
    
    private let store: StoreOf<ScrapFolderFeature>
    @ObservedObject var viewStore: ViewStoreOf<ScrapFolderFeature>
    
    init(store: StoreOf<ScrapFolderFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            naviagationBar
            ScrollView {
                LazyVGrid(columns: gridItem, spacing: 16.0) {
                    ForEach(0..<viewStore.folders.count, id: \.self) { index in
                        if index == viewStore.folders.count {
                            addFolderButtonView
                        } else {
                            NavigationLink(destination: {
                                ScrapListView(store: Store(initialState: ScrapListFeature.State(folderId: viewStore.folders[index].scrapFolderId ?? 0,
                                                                                                folderName: viewStore.folders[index].scrapFolderName ?? ""),
                                                           reducer: { ScrapListFeature() }))
                            }, label: {
                                folderItem(image: viewStore.folders[index].scrapFolderImg ?? "", 
                                           title: viewStore.folders[index].scrapFolderName ?? "")
                            })
//                            NavigationLinkStore(self.store.scope(state: \.$scrapList, action: ScrapFolderFeature.Action.scrapList),
//                                                onTap: {
//                                viewStore.send(.didTappedScrapFolder(folderId: viewStore.folders[index].scrapFolderId ?? 0, folderName: viewStore.folders[index].scrapFolderName ?? ""))
//                            }, destination: {
//                                ScrapListView(store: $0)
//                            }, label: {
//                                folderItem(image: viewStore.folders[index].scrapFolderImg ?? "", title: viewStore.folders[index].scrapFolderName ?? "")
//                            })
                        }
                    }
                }
                .padding(.horizontal, 16.0)
            }
        }
        .onAppear {
            viewStore.send(.viewDidLoad)
        }
        .modifier(FolderPopupTextFieldModifier(isShowFlag: $showPopup,
                                               folderPopupType: .add,
                                               complete: { foldername in
            viewStore.send(.addFolder(folderName: foldername))
        }))
    }
}

extension ScrapFolderView {
    private var naviagationBar: some View {
        HStack(spacing: 0.0) {
            Text(StringConstant.scrap)
                .font(.pretendard(.bold, size: 14.0))
                .foregroundColor(.black)
        }
        .frame(height: 48.0)
    }
    
    private func folderItem(image url: String, title: String) -> some View {
        VStack(spacing: 8.0) {
            KFImage(URL(string: url))
                .placeholder {
                    Image(uiImage: UIImage(named: "folderImage") ?? UIImage())
                        .resizable()
                }
                .resizable()
                .frame(width: gridItemHeight,
                       height: gridItemHeight)
                .scaledToFill()
            
            Text(title)
                .foregroundColor(.black)
                .font(.pretendard(.bold, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
        }
    }
    
    private var addFolderButtonView: some View {
        VStack(spacing: 8.0) {
            VStack(spacing: 4.0) {
                Text(StringConstant.addFolder)
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 16.0))
                Image("add_circle_blue")
            }
            .frame(height: gridItemHeight)
            .frame(maxWidth: .infinity,
                   alignment: .top)
            .overlay(Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                .foregroundColor(.gray_D3D4D5)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                showPopup = true
            }
            Text(StringConstant.folder)
                .foregroundColor(.clear)
                .font(.pretendard(.bold, size: 16.0))
        }
        
    }
}

struct ScrapFolderView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapFolderView(store: Store(initialState: ScrapFolderFeature.State(), reducer: { ScrapFolderFeature() }))
    }
}
