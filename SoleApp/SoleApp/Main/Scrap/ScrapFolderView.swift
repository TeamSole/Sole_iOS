//
//  ScrapFolderView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Kingfisher

struct ScrapFolderView: View {
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
                    ForEach(0..<5) { index in
                        if index == 4 {
                            addFolderButtonView
                        } else {
                            NavigationLink(destination: {
                                ScrapListView()
                            }, label: {
                                folderItem(image: nil, title: "기본 폴더")
                            })
                           
                        }
                    }
                }
                .padding(.horizontal, 16.0)
            }
        }
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
    
    private func folderItem(image url: URL?, title: String) -> some View {
        VStack(spacing: 8.0) {
            KFImage(url)
                .placeholder {
                    Image(uiImage: UIImage(named: "profile56") ?? UIImage())
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
        VStack(spacing: 4.0) {
            Text("폴더 추가")
                .foregroundColor(.black)
                .font(.pretendard(.reguler, size: 16.0))
            Image("add_circle_blue")
        }
        .frame(height: gridItemHeight)
        .frame(maxWidth: .infinity)
        .overlay(Rectangle()
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
            .foregroundColor(.gray_D3D4D5)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            print(44)
        }
        
    }
}

struct ScrapFolderView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapFolderView()
    }
}
