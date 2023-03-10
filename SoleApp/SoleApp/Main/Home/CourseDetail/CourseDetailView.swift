//
//  CourseDetailView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Kingfisher
import UIKit

struct CourseDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var availableWidth: CGFloat = 10
    @State private var isExpanded: Bool = false
    @State private var showActionSheet: Bool = false
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            ScrollView {
                LazyVStack(spacing: 0.0) {
                    mapView
                    profileSectionView
                    thinSectionDivider
                    courseSummarySectionView
                    thickSectionDivider
                    courseDetailSectionView
                }
            }
        }
        .navigationBarHidden(true)
        .actionSheet(isPresented: $showActionSheet, content: getActionSheet)
    }
}

extension CourseDetailView {
    private var navigationBar: some View {
        HStack(spacing: 10.0) {
            Image("arrow_back")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Image(systemName: "heart")
            Image("more-vertical")
                .onTapGesture {
                    showActionSheet = true
                }
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var mapView: some View {
        VStack(spacing: 0.0) {
            NaverMapView()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300.0)
    }
    
    private var profileSectionView: some View {
        HStack(alignment: .center, spacing: 0.0) {
            KFImage(nil)
                .placeholder {
                    Image(uiImage: UIImage(named: "profile24") ?? UIImage())
                        .resizable()
                        .frame(width: 40.0,
                               height: 40.0)
                }
                .frame(width: 40.0,
                       height: 40.0)
            VStack(spacing: 3.0) {
                Text("?????????")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                HStack(spacing: 7.0) {
                    Text("?????????")
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 12.0))
                    Color.black
                        .frame(width: 1.0,
                               height: 11.0)
                    Text("?????????")
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 12.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    
                }
            }
            .padding(.leading)
            Text("?????????")
                .foregroundColor(.blue_4708FA)
                .font(.pretendard(.reguler, size: 12.0))
                .frame(width: 62.0,
                       height: 20.0,
                       alignment: .center)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4.0)
                        .stroke(Color.blue_4708FA, lineWidth: 1.0)
                )
            
               
        }
        .frame(height: 76.0)
        .padding(.horizontal, 16.0)
    }
    
    private var courseSummarySectionView: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack(spacing: 0.0) {
                Text("?????? ??????")
                    .font(.pretendard(.bold, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("blackLove")
                Text("123")
                    .font(.pretendard(.reguler, size: 11.0))
                    .foregroundColor(.black)
            }
            Text("????????? ?????????????????? ?????? ?????? ?????? ???????????? ???????????? ???????????? ????????? ???????????? ??? ????????? ????????? ????????????. ????????? ???????????? ????????? ?????? ??????, ?????? ???????????? ????????? ???????????? ?????? ????????? ?????????. ????????? ??????????????? ???????????? ?????? ????????? ????????? ?????? ???????????? ????????? ????????? ??? ????????????!")
                .font(.pretendard(.reguler, size: 13.0))
                .foregroundColor(.black)
                .lineLimit(nil)
                .padding(.bottom, 8.0)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            Text(Date().toString())
                .font(.pretendard(.reguler, size: 12.0))
                .foregroundColor(.gray_404040)
            Text("????????? ??????")
                .font(.pretendard(.reguler, size: 12.0))
                .foregroundColor(.gray_404040)
            Color.clear
                .frame(height: 1.0)
                .readSize { size in
                    availableWidth = size.width
                }
            TagListView(availableWidth: availableWidth,
                        data:  ["1", "2", "3", "4"],
                        spacing: 8.0,
                        alignment: .leading,
                        isExpandedUserTagListView: .constant(false),
                        maxRows: .constant(0)) { item in
                HStack(spacing: 0.0) {
                    Text(item)
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 11.0))
                        .frame(height: 18.0)
                        .padding(.horizontal, 8.0)
                        .background(Color.gray_EDEDED)
                        .cornerRadius(4.0)
                }
                
            }
        }
        .padding(16.0)
    }
    
    private var courseDetailSectionView: some View {
        VStack(spacing: 0.0) {
            HStack(alignment: .center, spacing: 0.0) {
                Text("?????? ????????????")
                    .font(.pretendard(.bold, size: 14.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_up")
                    .rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
            }
            .padding(.horizontal, 16.0)
            .frame(height: 40.0)
            ForEach(0..<4) { index in
                courseDetailItem(index: index)
            }
        }
    }
    
    private func courseDetailItem(index: Int) -> some View {
        HStack(alignment: .top, spacing: 16.0) {
            Text("\(index)")
                .font(.pretendard(.bold, size: 12))
                .foregroundColor(.white)
                .frame(width: 20.0,
                       height: 20.0)
                .background(Color.blue_4708FA.cornerRadius(10.0))
            VStack(spacing: 0.0) {
                HStack(spacing: 12.0) {
                    Text("???????????? ?????? ?????? ?????????")
                        .font(.pretendard(.medium, size: 15.0))
                        .foregroundColor(.black)
                    Text("????????? ??????")
                        .font(.pretendard(.reguler, size: 12.0))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.bottom, 8.0)
                if isExpanded {
                    Text("?????? ????????? ???????????? 269 ?????????????????? 2???")
                        .font(.pretendard(.reguler, size: 12.0))
                        .foregroundColor(.gray_383838)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .padding(.bottom, 9.0)
                    HStack(spacing: 4.0) {
                        Image("info")
                        Text("????????????")
                            .font(.pretendard(.reguler, size: 12.0))
                            .foregroundColor(.blue_4708FA)
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                    }
                    .padding(.bottom, 15.0)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4.0) {
                            ForEach(0..<4) { index in
                                KFImage(nil)
                                    .placeholder {
                                        Image(uiImage: UIImage(named: "profile24") ?? UIImage())
                                            .resizable()
                                            .frame(width: 140.0,
                                                   height: 140.0)
                                    }
                                    .resizable()
                                    .frame(width: 140.0,
                                           height: 140.0)
                                    .cornerRadius(8.0)
                            }
                        }
                    }
                    VStack(spacing: 0.0) {
                        Text("??????????????????")
                            .font(.pretendard(.reguler, size: 11.0))
                            .foregroundColor(.gray_999999)
                            .padding(.vertical, 8.0)
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                        Color.gray_EDEDED
                            .frame(height: 1.0)
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                    }
                }
                    
            }
            .frame(maxWidth: .infinity,
                   alignment: .leading)
        }
        .padding(.top, 14.0)
        .padding(.leading, 16.0)
    }
    
    private var thinSectionDivider: some View {
        Color.gray_EDEDED
            .frame(height: 1.0)
            .frame(maxWidth: .infinity)
            .padding(.leading, 16.0)
    }
    
    private var thickSectionDivider: some View {
        Color.gray_EDEDED
            .frame(height: 3.0)
            .frame(maxWidth: .infinity)
    }
    
    func getActionSheet() -> ActionSheet {
        let button1: ActionSheet.Button = .default(Text("??????"))
        let button2: ActionSheet.Button = .default(Text("??????"))
        let button3: ActionSheet.Button = .cancel(Text("??????"))
        
        let title = Text("")
        
        return ActionSheet(title: title,
                           message: nil,
                           buttons: [button1, button2, button3])
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailView()
    }
}
