//
//  ScrapListView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Kingfisher

struct ScrapListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var isEditMode: Bool = false
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                LazyVStack(spacing: 0.0) {
                    listHeaderView
                    scrapList
                }
            }
        }
        .navigationBarHidden(true)
    }
}

extension ScrapListView {
    private var navigationBar: some View {
        HStack {
            Image("arrow_back")
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("폴더명")
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
                    }
            } else {
                Image("more-vertical")
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
                            .stroke(Color.gray_D3D4D5, lineWidth: 1.0)
                    )
                Text("삭제")
                    .font(.pretendard(.medium, size: 12.0))
                    .foregroundColor(.black)
                
                    .frame(width: 60.0,
                           height: 24.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12.0)
                            .stroke(Color.gray_D3D4D5, lineWidth: 1.0)
                    )
                
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
            ForEach(0..<4) { index in
                scrapItem(image: nil, title: "그라운드시소 전시", locationInfo: "서울 종로구", tagList: ["맛집", "카페", "친구와"])
                
            }
        }
        .padding(.horizontal, 16.0)
    }
    
    private func scrapItem(image url: URL?, title: String, locationInfo: String, tagList: [String]) -> some View {
        HStack(alignment: .top, spacing: 15.0) {
            KFImage(url)
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
                Text(title)
                    .font(.pretendard(.bold, size: 14.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.bottom, 7.0)
                Text(locationInfo)
                    .font(.pretendard(.reguler, size: 12.0))
                    .foregroundColor(.gray_999999)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.bottom, 7.0)
                HStack(spacing: 8.0) {
                    ForEach(0..<tagList.count, id: \.self) { index in
                        Text(tagList[index])
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
            if isEditMode {
                Image("radio_button_unchecked")
            }
        }
    }
}

struct ScrapListView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapListView()
    }
}
