//
//  ScrapView.swift
//  SoleApp
//
//  Created by SUN on 2/11/24.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct ScrapView: View {
    private let store: StoreOf<ScrapFeature>
    @ObservedObject var viewStore: ViewStoreOf<ScrapFeature>
    
    init(store: StoreOf<ScrapFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            topBar
            ScrollView {
                ForEach(viewStore.state.folders, id: \.scrapFolderId) { item in
                    folderItem(item)
                }
            }
        }
    }
}

extension ScrapView {
    private var topBar: some View {
        VStack(spacing: 0.0) {
            Text("폴더 선택")
                .font(.pretendard(.medium, size: 16.0))
                .padding(.vertical, 24.0)
        }
    }
    
    private func folderItem(_ folder: ScrapFolderResponseModel.DataModel) -> some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 16.0) {
                KFImage(URL(string: folder.scrapFolderImg ?? ""))
                    .placeholder {
                        Image(uiImage: UIImage(named: "folder_placeholder") ?? UIImage())
                            .resizable()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40.0, height: 40.0)
                    .clipped()
                    .cornerRadius(4.0)
                
                Text(folder.scrapFolderName ?? "")
                    .foregroundColor(.black)
                    .font(.pretendard(.bold, size: 16.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
            }
            .onTapGesture {
                <#code#>
            }
            
            Color.gray_EDEDED
                .frame(height: 1.0)
                .padding(.vertical, 12.0)
        }
        .padding(.horizontal, 16.0)
    }
}

#Preview {
    ScrapView(store: Store(initialState: ScrapFeature.State(selectedCouseId: 0), reducer: { ScrapFeature() }))
}
