//
//  SignUpCompleteView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/16.
//

import SwiftUI

struct SignUpCompleteView: View {
    var body: some View {
        VStack(spacing: 0.0) {
            completeDescriptionView
            logoView
        }
    }
}

extension SignUpCompleteView {
    private var completeDescriptionView: some View {
        VStack(spacing: 20.0) {
            Text("회원가입 완료!")
                .foregroundColor(.black)
                .font(.pretendard(.bold, size: 28.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
            Text("쏠과 함께 지도 위에 나만의 발자국을 남겨봐요 :)")
                .foregroundColor(.gray_404040)
                .font(.pretendard(.reguler, size: 14.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
        }
        .padding(.horizontal, 16.0)
        .padding(.top, 50.0)
    }
    
    private var logoView: some View {
        VStack(spacing: 0.0) {
            Image("onlyLogo")
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
    }
}

struct SignUpCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpCompleteView()
    }
}
