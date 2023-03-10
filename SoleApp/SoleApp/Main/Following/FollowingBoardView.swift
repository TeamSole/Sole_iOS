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
                            NavigationLink("\(index)", destination: Text("\(index)"))
                            
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
    
    private func courseHeader(image url: URL?, name: String, isScraped: Bool) {
        HStack(spacing: 0.0) {
            
        }
    }
}

struct FollowingBoardView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingBoardView()
    }
}
