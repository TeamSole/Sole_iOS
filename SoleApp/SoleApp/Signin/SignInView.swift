//
//  SignInView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/15.
//

import SwiftUI

struct SignInView: View {
    @State private var showSignUpView: Bool = false
    
    let signUpViewModel = SignUpViewModel()
    var body: some View {
        NavigationView {
            VStack(spacing: 0.0) {
                logoView
                SignInButtonsView
                addminInfoView
                navigateToSignUpView
            }
        }
    }
}

extension SignInView {
    private var logoView: some View {
        VStack(spacing: 0.0) {
            Image("sole_splash")
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
    }
    
    private var SignInButtonsView: some View {
        VStack(spacing: 8.0) {
            kakaoSigninView
            appleSigninView
        }
        .padding(.bottom, 48.0)
    }
    
    private var kakaoSigninView: some View {
        ZStack() {
            Image("kakao_icon")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.leading, 16.0)
            Text("Kakao로 계속하기")
                .font(.pretendard(.medium, size: 16.0))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48.0)
        .background(Color.yellow_FBE520)
        .cornerRadius(4.0)
        .padding(.horizontal, 16.0)
        .contentShape(Rectangle())
        .onTapGesture {
            showSignUpView = true
        }
    }
    
    private var appleSigninView: some View {
        ZStack() {
            Image("apple_icon")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.leading, 16.0)
            Text("Apple로 계속하기")
                .font(.pretendard(.medium, size: 16.0))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48.0)
        .background(Color.black)
        .cornerRadius(4.0)
        .padding(.horizontal, 16.0)
    }
    
    private var addminInfoView: some View {
        VStack(spacing: 4.0) {
            Text("개인정보처리방침")
                .font(.pretendard(.reguler, size: 10.0))
                .foregroundColor(.gray_999999)
            Text("회원 정보 문의: team.sole12@gmail.com")
                .font(.pretendard(.reguler, size: 10.0))
                .foregroundColor(.gray_999999)
        }
        .padding(.bottom, 16.0)
    }
    
    private var navigateToSignUpView: some View {
        NavigationLink(destination:
                        SignUpAgreeTermsView(viewModel: signUpViewModel),
                       isActive: $showSignUpView,
                       label: {
            EmptyView()
        })
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
