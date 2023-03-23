//
//  HistoryView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/12.
//

import SwiftUI
import Kingfisher

struct HistoryView: View {
    typealias History = HistoryModelResponse.DataModel
    @StateObject var viewModel: HistoryViewModel = HistoryViewModel()
    @State private var isShowSelectTagView: Bool = false
    private let filterType: [String] = ["장소", "동행", "교통"]
    var body: some View {
        ZStack() {
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
            floatingButton
        }
        .onAppear {
            viewModel.getUserProfile()
            viewModel.getUserHistoies()
        }
        .sheet(isPresented: $isShowSelectTagView,
               content: {
            SelectTagView(selectType: .filter, complete: {place, with, trans in
                if place.isEmpty && with.isEmpty && trans.isEmpty {
                    viewModel.getUserHistoies()
                } else {
                    viewModel.getUserHistoiesWithParameter(place: place, with: with, tras: trans)
                }
            })
        })
    }
}

extension HistoryView {
    private var naviagationBar: some View {
        HStack(spacing: 0.0) {
            Text("나의 기록")
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(height: 48.0)
    }
    
    private var profileSectionView: some View {
        HStack(alignment: .top, spacing: 0.0) {
            KFImage(URL(string: Utility.load(key: Constant.profileImage)))
                .placeholder {
                    Image(uiImage: UIImage(named: "profile56") ?? UIImage())
                        .resizable()
                        .frame(width: 56.0,
                               height: 56.0)
                }
                .resizable()
                .frame(width: 56.0,
                       height: 56.0)
                .cornerRadius(.infinity)
            VStack(spacing: 0.0) {
                Text("\(viewModel.profileDescription.nickname ?? "-")님의 발자국")
                    .foregroundColor(.black)
                    .font(.pretendard(.bold, size: 16.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Text("지금까지 \(viewModel.profileDescription.totalDate ?? 0)일간 \(viewModel.profileDescription.totalPlaces ?? 0)곳의 장소를 방문하며, 이번달 총 \(viewModel.profileDescription.totalCourses ?? 0)개의 코스를 기록했어요.")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.vertical, 16.0)
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
            if viewModel.apiRequestStatus == false &&
                viewModel.histories.isEmpty {
                emptyResultView
            } else {
                ForEach(0..<viewModel.histories.count, id: \.self) { index in
                    NavigationLink (destination: {
                        CourseDetailView(courseId: viewModel.histories[index].courseId ?? 0,
                                         isScrapped: viewModel.histories[index].like ?? false)
                    }, label: {
                        courseHistoryItem(item: viewModel.histories[index])
                    })
                    
                }
            }
        }
        .padding(16.0)
    }
    
    private func courseHistoryItem(item: History) -> some View {
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
            Text("아직 추가한 장소가 없습니다.")
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .padding(.top, 100.0)
    }
    
    private var floatingButton: some View {
        GeometryReader {geo in
            HStack(alignment: .bottom, spacing: 0.0) {
                Spacer()
                VStack(alignment: .trailing, spacing: 0.0) {
                    Spacer()
                    NavigationLink(destination: {
                        RegisterCouseView()
                    }, label: {
                        HStack(spacing: 0.0) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 15.0,
                                       height: 15.0)
                        }
                        .frame(width: 48.0,
                               height: 48.0)
                        .foregroundColor(.white)
                        .background(Circle()
                            .fill(Color.blue_4708FA)
                            .cornerRadius(.infinity))
                    })
                }
                .padding(.trailing, 16.0)
                .padding(.bottom, 16.0)
            }
        }
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
