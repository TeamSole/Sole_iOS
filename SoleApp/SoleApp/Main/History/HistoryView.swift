//
//  HistoryView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/12.
//

import SwiftUI
import Kingfisher

struct HistoryView: View {
    @State private var isShowSelectTagView: Bool = false
    private let filterType: [String] = ["장소", "동행", "교통"]
    var body: some View {
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
        .sheet(isPresented: $isShowSelectTagView,
               content: {
            SelectTagView()
        })
    }
}

extension HistoryView {
    private var naviagationBar: some View {
        HStack(spacing: 0.0) {
            Text("나의 기록")
                .font(.pretendard(.bold, size: 14.0))
                .foregroundColor(.black)
        }
        .frame(height: 48.0)
    }
    
    private var profileSectionView: some View {
        HStack(alignment: .top, spacing: 0.0) {
            KFImage(nil)
                .placeholder {
                    Image(uiImage: UIImage(named: "profile56") ?? UIImage())
                        .resizable()
                        .frame(width: 56.0,
                               height: 56.0)
                }
                .frame(width: 56.0,
                       height: 56.0)
            VStack(spacing: 0.0) {
                Text("닉네임님의 발자국")
                    .foregroundColor(.black)
                    .font(.pretendard(.bold, size: 16.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Text("지금까지 00일간 00곳의 장소를 방문하며, 이번달 총 00개의 코스를 기록했어요.")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.vertical, 16.0)
                Text("가장 많이 방문한 지역은 00이고 00 00 이동해서 00을 다녔어요.")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
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
            Text("기록한 코스")
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
            ForEach(0..<4) { index in
                courseHistoryItem(image: nil, title: "그라운드시소 전시", locationInfo: "서울 종로구", tagList: ["맛집", "카페", "친구와"])
                
            }
        }
        .padding(16.0)
    }
    
    private func courseHistoryItem(image url: URL?, title: String, locationInfo: String, tagList: [String]) -> some View {
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
            
        }
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
