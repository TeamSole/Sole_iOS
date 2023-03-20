//
//  FollowingBoardView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/08.
//

import SwiftUI
import Kingfisher

struct FollowingBoardView: View {
    typealias boardItem = FollowBoardModelResponse.DataModel
    @StateObject var viewModel: FollowingBoardViewModel = FollowingBoardViewModel()
    var body: some View {
            VStack(spacing: 0.0) {
                navigationView
                ScrollView {
                    if viewModel.apiRequestStatus == false &&
                        viewModel.boardList.isEmpty {
                        emptyResultView
                    } else {
                        VStack(spacing: 16.0) {
                            ForEach(0..<viewModel.boardList.count, id: \.self) { index in
                                courseListItem(courseId: viewModel.boardList[index].courseId ?? 0,
                                               index: index,
                                               image: viewModel.boardList[index].profileImg,
                                               image: viewModel.boardList[index].thumbnailImg,
                                               userName: viewModel.boardList[index].nickname ?? "",
                                               title: viewModel.boardList[index].title ?? "",
                                               description: viewModel.boardList[index].description ?? "")
                            }
                        }
                    } 
                }
            }
            .frame(maxHeight: .infinity)
            .navigationBarHidden(true)
            .onAppear {
                viewModel.getFollowingBoardList()
            }
    }
}

extension FollowingBoardView {
    private var navigationView: some View {
        ZStack(alignment: .trailing) {
            Text("팔로잉")
                .foregroundColor(.black)
                .font(Font(UIFont.pretendardBold(size: 16.0)))
                .frame(maxWidth: .infinity,
                       alignment: .center)
            NavigationLink(destination: {
                FollowingUserListView()
            }, label: {
                Image("people_alt")
            })
            .padding(.trailing, 15.0)
        }
        .frame(height: 46.0)
    }
    
    private func courseListItem(courseId: Int, index: Int, image profileImgurl: String?, image thumbnailImgurl: String?, userName: String, title: String, description: String) -> some View {
        VStack(spacing: 0.0) {
            courseHeader(courseId: courseId, image: URL(string: profileImgurl ?? ""), userName: userName, index: index)
            courseItem(courseId: courseId, image: URL(string: thumbnailImgurl ?? ""), courseName: title, description: description)
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding(.horizontal, 16.0)
    }
    
    private func courseHeader(courseId: Int, image url: URL?, userName: String, index: Int) -> some View {
        HStack(spacing: 0.0) {
            KFImage(url)
                .resizable()
                .placeholder {
                    Image(uiImage: UIImage(named: "profile24") ?? UIImage())
                        .resizable()
                        .frame(width: 32.0,
                               height: 32.0)
                }
                .frame(width: 32.0,
                       height: 32.0)
                .cornerRadius(.infinity)
                .padding(.trailing, 8.0)
            Text(userName)
                .font(Font(UIFont.pretendardRegular(size: 14.0)))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            Image(viewModel.boardList[index].like == true ? "love_selected" : "love")
                .onTapGesture {
                    viewModel.boardList[index].like?.toggle()
                    viewModel.scrap(courseId: courseId)
                }
        }
        .frame(height: 52.0)
    }
    
    private func courseItem(courseId: Int, image url: URL?, courseName: String, description: String) -> some View {
        VStack(spacing: 0.0) {
            KFImage(url)
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 186.0)
                .padding(.bottom, 8.0)
            Text(courseName)
                .font(Font(UIFont.pretendardBold(size: 16.0)))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.bottom, 4.0)
            Text(description)
                .font(Font(UIFont.pretendardRegular(size: 13.0)))
                .lineSpacing(4.0)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .lineLimit(nil)
            
        }
    }
    
    
    private var emptyResultView: some View {
        VStack(spacing: 17.0) {
            Image("emptyResult")
            Text("아직 팔로우한 유저의 장소가 없습니다.")
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
        .padding(.top, 100.0)
    }
    
}

struct FollowingBoardView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingBoardView()
    }
}
