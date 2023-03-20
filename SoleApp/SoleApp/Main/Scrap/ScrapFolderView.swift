//
//  ScrapFolderView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Kingfisher

struct ScrapFolderView: View {
    @StateObject var viewModel: ScrapFolderViewModel = ScrapFolderViewModel()
    @State private var showPopup: Bool = false
    private let gridItem: [GridItem] = [
        GridItem(.adaptive(minimum: 100.0), spacing: 16.0),
        GridItem(.adaptive(minimum: 100.0), spacing: 16.0)
    ]
    
    private let gridItemHeight: CGFloat = (UIScreen.main.bounds.width - 48) / 2
    var body: some View {
        VStack(spacing: 0.0) {
            naviagationBar
            ScrollView {
                LazyVGrid(columns: gridItem, spacing: 16.0) {
                    ForEach(0..<viewModel.folders.count + 1, id: \.self) { index in
                        if index == viewModel.folders.count {
                            addFolderButtonView
                        } else {
                            NavigationLink(destination: {
                                ScrapListView(folderId: viewModel.folders[index].scrapFolderId ?? 0,
                                              folderName: viewModel.folders[index].scrapFolderName ?? "")
                            }, label: {
                                folderItem(image: viewModel.folders[index].scrapFolderImg ?? "", title: viewModel.folders[index].scrapFolderName ?? "")
                            })
                           
                        }
                    }
                }
                .padding(.horizontal, 16.0)
            }
        }
        .onAppear {
            viewModel.getFolders()
        }
        .modifier(FolderPopupTextFieldModifier(isShowFlag: $showPopup,
                                               folderPopupType: .add,
                                               complete: { foldername in
            viewModel.addFolder(folderName: foldername)
        }))
    }
}

extension ScrapFolderView {
    private var naviagationBar: some View {
        HStack(spacing: 0.0) {
            Text("스크랩")
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
                .frame(height: gridItemHeight)
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
                Text("폴더 추가")
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
            Text("폴더")
                .foregroundColor(.clear)
                .font(.pretendard(.bold, size: 16.0))
        }
        
    }
}

struct ScrapFolderView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapFolderView()
    }
}
