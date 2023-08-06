//
//  SignInView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/15.
//

import SwiftUI
import ComposableArchitecture

struct SignInView: View {
    let store: StoreOf<SignInFeature>

    @State private var showSignUpView: Bool = false
   
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack(spacing: 0.0) {
                    logoView
                    SignInButtonsView(viewStore: viewStore)
                    addminInfoView
                    navigateToSignUpView(viewStore: viewStore)
                }
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
    
    private func SignInButtonsView(viewStore: ViewStore<SignInFeature.State, SignInFeature.Action>) -> some View {
        VStack(spacing: 8.0) {
            kakaoSigninView(viewStore: viewStore)
            appleSigninView(viewStore: viewStore)
        }
        .padding(.bottom, 48.0)
    }
    
    private func kakaoSigninView(viewStore: ViewStore<SignInFeature.State, SignInFeature.Action>) -> some View {
        ZStack() {
            Image("kakao_icon")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.leading, 16.0)
            Text(StringConstant.signInWithKakao)
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
            viewStore.send(.didTapSignWithKakao)
        }
    }
    
    private func appleSigninView(viewStore: ViewStore<SignInFeature.State, SignInFeature.Action>) -> some View {
        ZStack() {
            Image("apple_icon")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.leading, 16.0)
            Text(StringConstant.signInWithApple)
                .font(.pretendard(.medium, size: 16.0))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48.0)
        .background(Color.black)
        .cornerRadius(4.0)
        .padding(.horizontal, 16.0)
        .contentShape(Rectangle())
        .onTapGesture {
            
        }
    }
    
    private var addminInfoView: some View {
        VStack(spacing: 4.0) {
            Text(StringConstant.privacyPolicy)
                .font(.pretendard(.reguler, size: 10.0))
                .foregroundColor(.gray_999999)
            Text(StringConstant.helpCenterMail)
                .font(.pretendard(.reguler, size: 10.0))
                .foregroundColor(.gray_999999)
        }
        .padding(.bottom, 16.0)
    }
    
    private func navigateToSignUpView(viewStore: ViewStore<SignInFeature.State, SignInFeature.Action>) -> some View {
        NavigationLink(destination:
                        SignUpAgreeTermsView(viewModel: .init()),
                       isActive: .constant(viewStore.isShowSignUpView),
                       label: {
            EmptyView()
        })
        .isDetailLink(false)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(store: Store(initialState: SignInFeature.State(),
                                  reducer: { SignInFeature() }))
    }
}
