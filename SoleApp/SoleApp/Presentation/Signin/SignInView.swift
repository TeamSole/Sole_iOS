//
//  SignInView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/15.
//

import SwiftUI
import ComposableArchitecture
import AuthenticationServices

struct SignInView: View {
    private let store: StoreOf<SignInFeature>
    @ObservedObject var viewStore: ViewStoreOf<SignInFeature>
    
    init(store: StoreOf<SignInFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack(spacing: 0.0) {
                    logoView
                    SignInButtonsView()
                    addminInfoView
                    navigateToSignUpView()
                }
            }
            .navigationViewStyle(.stack)
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
    
    private func SignInButtonsView() -> some View {
        VStack(spacing: 8.0) {
            kakaoSigninView()
            appleSigninView()
        }
        .padding(.bottom, 48.0)
    }
    
    private func kakaoSigninView() -> some View {
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
    
    private func appleSigninView() -> some View {
        ZStack() {
            SignInWithAppleButton { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Apple Login Successful")
                    switch authResults.credential{
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        let IdentityToken = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8)
                        viewStore.send(.didTapSignWithApple(token: IdentityToken))
                        
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                }
            }
            .overlay(
                ZStack {
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
                    .allowsHitTesting(false))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48.0)
        .cornerRadius(4.0)
        .padding(.horizontal, 16.0)
        
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
    
    private func navigateToSignUpView() -> some View {
        NavigationLinkStore(store.scope(state: \.$optionalSignUpAgreeTerms, action: SignInFeature.Action.optionalSignUpAgreeTerms),
                            onTap: {
            viewStore.send(.setNavigaiton(isActive: true))
        },
                            destination: { SignUpAgreeTermsView(store: $0) },
                            label: {
            EmptyView()
        })
//        NavigationLink(destination: IfLetStore(self.store.scope(state: \.optionalSignUpAgreeTerms,
//                                                                action: SignInFeature.Action.optionalSignUpAgreeTerms),
//                                               then: { store in
//            SignUpAgreeTermsView(viewModel: .init(),
//                                 store: store,
//                                 viewStore: ViewStore(store, observe: { $0 }))
//        })
//                       ,
//                       isActive: viewStore.binding(get: \.isShowSignUpView, send: SignInFeature.Action.setNavigaiton(isActive: )),
//                       label: {
//            EmptyView()
//        })
//        .onDisappear {
//            viewStore.send(.setPresentedFlag)
//        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(store: Store(initialState: SignInFeature.State(),
                                  reducer: { SignInFeature() }))
    }
}
