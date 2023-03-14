//
//  FollowingBoardView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/08.
//

import SwiftUI
import Kingfisher

struct FollowingBoardView: View {
    var body: some View {
            VStack(spacing: 0.0) {
                navigationView
                ScrollView {
                    VStack(spacing: 0.0) {
                        ForEach(0..<50, id: \.self) { index in
                            NavigationLink(destination: {
                                Text("\(index)")
                            }, label: {
                                courseListItem()
                            })
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .navigationBarHidden(true)
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
            Image("people_alt")
                .padding(.trailing, 15.0)
        }
        .frame(height: 46.0)
    }
    
    private func courseListItem() -> some View {
        VStack(spacing: 0.0) {
            courseHeader(image: nil, userName: "닉네임", isScraped: true)
            courseItem(image: nil, courseName: "코스이름", description: "전시를 관람하다보면 창을 통해 빛이 들어오는 구도까지 생각해서 전시를 기획하는 것 같다는 느낌을 받았어요. 요시고 사진전에 이어서 이번 겨울, 많은 사람들이 사랑할 전시회가 되지 않을까 싶어요. 평일에 방문했더니 관람객이 별로 없어서 웨이팅 없이 여유롭게 전시를 관람할 수 있었어요!")
        }
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .padding(.horizontal, 16.0)
    }
    
    private func courseHeader(image url: URL?, userName: String, isScraped: Bool) -> some View {
        HStack(spacing: 0.0) {
            KFImage(url)
                .resizable()
                .frame(width: 32.0,
                       height: 32.0)
                .padding(.trailing, 8.0)
            Text(userName)
                .font(Font(UIFont.pretendardRegular(size: 14.0)))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            Image(isScraped ? "love_selected" : "love")
                .onTapGesture {
//                    isScraped.toggle()
                }
        }
        .frame(height: 52.0)
    }
    
    private func courseItem(image url: URL?, courseName: String, description: String) -> some View {
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
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .lineLimit(nil)
            
        }
    }
    
}

struct FollowingBoardView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingBoardView()
    }
}
