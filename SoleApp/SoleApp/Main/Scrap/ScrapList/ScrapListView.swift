//
//  ScrapListView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Kingfisher

struct ScrapListView: View {
    typealias Scrap = ScrapListModelResponse.DataModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: ScrapListViewModel = ScrapListViewModel()
    @State private var isEditMode: Bool = false
    var folderId: Int

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
            viewModel.getScraps(folderId: folderId)
        }
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
            ForEach(0..<viewModel.scraps.count, id: \.self) { index in
                scrapItem(item: viewModel.scraps[index])
                
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
                Text(item.title ?? "")
                    .font(.pretendard(.bold, size: 14.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.bottom, 7.0)
                Text("\(item.address ?? "") \(item.duration ?? 0)시간 소요 \(item.distance ?? 0)km 이동")
                    .font(.pretendard(.reguler, size: 12.0))
                    .foregroundColor(.gray_999999)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.bottom, 7.0)
                HStack(spacing: 8.0) {
                    ForEach(0..<["라면", "라면"].count, id: \.self) { index in
                        Text(["라면", "라면"][index])
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
}

struct ScrapListView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapListView(folderId: 0)
    }
}
