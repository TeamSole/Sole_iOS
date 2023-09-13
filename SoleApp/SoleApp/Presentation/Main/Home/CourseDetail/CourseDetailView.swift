//
//  CourseDetailView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/14.
//

import SwiftUI
import Kingfisher
import UIKit
import ComposableArchitecture

struct CourseDetailView: View {
    typealias Place = CourseDetailModelResponse.PlaceResponseDtos
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: CourseDetailViewModel = CourseDetailViewModel()
    @State private var availableWidth: CGFloat = 10
    @State private var isExpanded: Bool = false
    
    @State private var showActionSheet: Bool = false
    @State private var showPopup: Bool = false
    @State private var alertType: AlertType = .declare
    @State private var isFollowing: Bool = true
    @State private var showCourseEditView: Bool = false

    var courseId: Int = 0
    @State private var isScrapped: Bool = false
    
    private let store: StoreOf<CourseDetailFeature>
    @ObservedObject var viewStore: ViewStoreOf<CourseDetailFeature>
    
    init(store: StoreOf<CourseDetailFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
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
            navigateToCourseEditView
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.getCourseDetail(courseId: courseId)
        }
        .actionSheet(isPresented: $showActionSheet, content: getActionSheet)
        .modifier(BasePopupModifier(isShowFlag: $showPopup, detailViewAlertType: alertType,
                                            complete: {
            if alertType == .remove {
                viewModel.removeCourse(courseId: courseId, complete: {
                    presentationMode.wrappedValue.dismiss()
                })
            } else if alertType == .declare {
                viewModel.declareCourse(courseId: courseId)
            }
        }))
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
            Image(isScrapped ? "love_selected" : "love")
                .onTapGesture {
                    isScrapped.toggle()
                    viewModel.scrap(courseId: courseId)
                }
            if viewModel.courseDetail.checkWriter == true {
                Image("more-vertical")
                    .onTapGesture {
                        showActionSheet = true
                    }
            } else {
                Image("report")
                    .onTapGesture {
                        alertType = .declare
                        showPopup = true
                    }
            }
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var mapView: some View {
        VStack(spacing: 0.0) {
            NaverMapView(places: $viewModel.courseDetail)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300.0)
    }
    
    private var profileSectionView: some View {
        HStack(alignment: .center, spacing: 0.0) {
            KFImage(URL(string: viewModel.courseDetail.writer?.profileImgUrl ?? ""))
                .placeholder {
                    Image(uiImage: UIImage(named: "profile24") ?? UIImage())
                        .resizable()
                        .frame(width: 40.0,
                               height: 40.0)
                }
                .resizable()
                .scaledToFill()
                .frame(width: 40.0,
                       height: 40.0)
                .cornerRadius(.infinity)
            VStack(spacing: 3.0) {
                Text(viewModel.courseDetail.writer?.nickname ?? "")
                    .foregroundColor(.black)
                    .font(.pretendard(.reguler, size: 14.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                HStack(spacing: 7.0) {
                    Text("\(StringConstant.follower) \(viewModel.courseDetail.follower ?? 0)")
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 12.0))
                    Color.black
                        .frame(width: 1.0,
                               height: 11.0)
                    Text("\(StringConstant.following) \(viewModel.courseDetail.following ?? 0)")
                        .foregroundColor(.black)
                        .font(.pretendard(.reguler, size: 12.0))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    
                }
            }
            .padding(.leading)
            Text(viewModel.courseDetail.isFollowing ? StringConstant.following : StringConstant.follow)
                .foregroundColor(viewModel.courseDetail.isFollowing ? .blue_4708FA : .white)
                .font(.pretendard(.reguler, size: 12.0))
                .frame(width: 62.0,
                       height: 20.0,
                       alignment: .center)
                .background(viewModel.courseDetail.isFollowing ? Color.white : Color.blue_4708FA)
                .cornerRadius(4.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 4.0)
                        .stroke(Color.blue_4708FA, lineWidth: 1.0)
                )
                .isHidden(viewModel.courseDetail.checkWriter == true)
                .onTapGesture {
                    if viewModel.courseDetail.isFollowing {
                        viewModel.courseDetail.followStatus = "FOLLOWER"
                    } else {
                        viewModel.courseDetail.followStatus = "FOLLOWING"
                    }
                    viewModel.follow(memberId: viewModel.courseDetail.writer?.memberId ?? 0)
                }
            
               
        }
        .frame(height: 76.0)
        .padding(.horizontal, 16.0)
    }
    
    private var courseSummarySectionView: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack(spacing: 0.0) {
                Text(viewModel.courseDetail.title ?? "")
                    .font(.pretendard(.bold, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("blackLove")
                    .padding(.trailing, 4.0)
                Text("\(viewModel.courseDetail.scrapCount ?? 0)")
                    .font(.pretendard(.reguler, size: 11.0))
                    .foregroundColor(.black)
            }
            Text(viewModel.courseDetail.description ?? "")
                .font(.pretendard(.reguler, size: 13.0))
                .lineSpacing(4.0)
                .foregroundColor(.black)
                .lineLimit(nil)
                .padding(.bottom, 8.0)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            Text(viewModel.courseDetail.startDate ?? "")
                .font(.pretendard(.reguler, size: 12.0))
                .foregroundColor(.gray_404040)
            Text("\(viewModel.courseDetail.address ?? "") · \(viewModel.courseDetail.computedDuration) · \(viewModel.courseDetail.scaledDistance) 이동")
                .font(.pretendard(.reguler, size: 12.0))
                .foregroundColor(.gray_404040)
            Color.clear
                .frame(height: 1.0)
                .readSize { size in
                    availableWidth = size.width
                }
            TagListView(availableWidth: availableWidth,
                        data: viewModel.courseDetail.cateogoryTitles,
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
                Text(StringConstant.watchCourseDetail)
                    .font(.pretendard(.bold, size: 14.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_down")
                    .rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
            }
            .padding(.horizontal, 16.0)
            .frame(height: 40.0)
            ForEach(0..<(viewModel.courseDetail.placeResponseDtos?.count ?? 0), id: \.self) { index in
                courseDetailItem(item: viewModel.courseDetail.placeResponseDtos?[index] ?? Place(), index: index)
            }
        }
    }
    
    private func courseDetailItem(item: Place, index: Int) -> some View {
        HStack(alignment: .top, spacing: 16.0) {
            Text("\(index + 1)")
                .font(.pretendard(.bold, size: 12))
                .foregroundColor(.white)
                .frame(width: 20.0,
                       height: 20.0)
                .background(Color.blue_4708FA.cornerRadius(10.0))
            VStack(spacing: 0.0) {
                HStack(spacing: 12.0) {
                    Text(item.placeName ?? "")
                        .font(.pretendard(.medium, size: 15.0))
                        .foregroundColor(.black)
                    Text(item.description ?? "")
                        .font(.pretendard(.reguler, size: 12.0))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.bottom, 8.0)
                if isExpanded {
                    Text(item.address ?? "")
                        .font(.pretendard(.reguler, size: 12.0))
                        .foregroundColor(.gray_383838)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .padding(.bottom, 9.0)
                        .isHidden(item.address?.isEmpty == true, remove: true)
                    HStack(spacing: 4.0) {
                        Image("info")
                        Text(StringConstant.moreInformation)
                            .font(.pretendard(.reguler, size: 12.0))
                            .foregroundColor(.blue_4708FA)
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                            .onTapGesture {
                                let query: String = "nmap://place?lat=\(item.latitude ?? 0.0)&lng=\(item.longitude ?? 0.0)&name=\(item.placeName ?? "")&appname=com.sole.ios.app"
                                let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                                let url = URL(string: encodedQuery)!
                                UIApplication.shared.open(url)
                            }
                    }
                    .padding(.bottom, 15.0)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4.0) {
                            ForEach(0..<(item.placeImgUrls?.count ?? 0), id: \.self) { index in
                                KFImage(URL(string: item.placeImgUrls?[index] ?? ""))
                                    .placeholder {
                                        Color.gray_D3D4D5
                                            .frame(width: 140.0,
                                                   height: 140.0)
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140.0,
                                           height: 140.0)
                                    .cornerRadius(8.0)
                            }
                        }
                    }
//                    VStack(spacing: 0.0) {
//                        Text("다음장소까지")
//                            .font(.pretendard(.reguler, size: 11.0))
//                            .foregroundColor(.gray_999999)
//                            .padding(.vertical, 8.0)
//                            .frame(maxWidth: .infinity,
//                                   alignment: .leading)
//                        Color.gray_EDEDED
//                            .frame(height: 1.0)
//                            .frame(maxWidth: .infinity,
//                                   alignment: .leading)
//                    }
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
        let button1: ActionSheet.Button = .default(Text(StringConstant.fix),
                                                   action: {
            showCourseEditView = true
        })
        let button2: ActionSheet.Button = .default(Text(StringConstant.delete), action: {
            alertType = .remove
            showPopup = true
        })
        let button3: ActionSheet.Button = .cancel(Text(StringConstant.cancel))
        
        let title = Text("")
        
        return ActionSheet(title: title,
                           message: nil,
                           buttons: [button1, button2, button3])
    }
    
    private var navigateToCourseEditView: some View {
        NavigationLink(isActive: $showCourseEditView,
                       destination: {
            CourseEditView(courseDetail: viewModel.courseDetail)
        }, label: {
            EmptyView()
        })
//        NavigationLink(destination: ,
//                       isActive: ,
//                       label: { })
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailView(store: Store(initialState: CourseDetailFeature.State(courseId: 0), reducer: { CourseDetailFeature() }))
    }
}
