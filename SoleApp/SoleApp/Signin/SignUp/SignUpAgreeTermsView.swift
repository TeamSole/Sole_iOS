//
//  SignUpAgreeTermsView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/15.
//

import SwiftUI
import ComposableArchitecture

struct SignUpAgreeTermsView: View {
    private let store: StoreOf<SignUpAgreeTermsFeature>
    @ObservedObject var viewStore: ViewStoreOf<SignUpAgreeTermsFeature>
    
    init(store: StoreOf<SignUpAgreeTermsFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            descriptionView
            allCheckBoxView
            checkTermsView
            navigateToSignUpUserInfoView
        }
        .navigationBarHidden(true)
    }
}

extension SignUpAgreeTermsView {
    private var navigationBar: some View {
        ZStack {
            Image("arrow_back")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .onTapGesture {
                    viewStore.send(.didTappedBackButton)
                }
            Text(StringConstant.signUp)
                .foregroundColor(.black)
                .font(.pretendard(.medium, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .center)
        }
        .frame(height: 48.0)
        .padding(.horizontal, 16.0)
    }
    
    private var descriptionView: some View {
        VStack(spacing: 0.0) {
            Text(StringConstant.helloWeAreSole)
                .foregroundColor(.black)
                .font(.pretendard(.bold, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.vertical, 36.0)
            Text(StringConstant.pleaseAgreeOfTermsForSignUp)
                .font(.pretendard(.bold, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
        }
        .padding(.horizontal, 16.0)
        .padding(.bottom, 16.0)
    }
    
    private var allCheckBoxView: some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 14.0) {
                Image(viewStore.isSelectedAllTerms
                      ? "check_circle"
                      : "radio_button_unchecked")
                    .onTapGesture {
                        viewStore.send(.didTappedAllTermAgree)
                    }
                Text(StringConstant.agreeAllTerms)
                    .font(.pretendard(.bold, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
            }
            Color.gray_D3D4D5
                .frame(height: 1.0)
                .padding(.vertical, 16.0)
        }
        .padding(.horizontal, 16.0)
    }
    
    private var checkTermsView: some View {
        VStack(spacing: 16.0) {
            HStack(spacing: 14.0) {
                Image(viewStore.isSelectedFirstTerm
                      ? "check_circle"
                      : "radio_button_unchecked")
                .onTapGesture {
                    viewStore.send(.didTappedFirstTerm)
                }
                Text(StringConstant.terms1ForSignUp)
                    .font(.pretendard(.reguler, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_right")
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: "https://team-sole.notion.site/64e1f0366c8a4f65ac0a3040776594b3")!)
                    }
            }
            
            HStack(spacing: 14.0) {
                Image(viewStore.isSelectedSecondTerm
                      ? "check_circle"
                      : "radio_button_unchecked")
                .onTapGesture {
                    viewStore.send(.didTappedSecondTerm)
                }
                Text(StringConstant.terms2ForSignUp)
                    .font(.pretendard(.reguler, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_right")
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: "https://team-sole.notion.site/8c353f0248ef4b838797863738c7b458")!)
                    }
            }
            
            HStack(spacing: 14.0) {
                Image(viewStore.isSelectedThirdTerm
                      ? "check_circle"
                      : "radio_button_unchecked")
                .onTapGesture {
                    viewStore.send(.didTappedThirdTerm)
                }
                Text(StringConstant.terms3ForSignUp)
                    .font(.pretendard(.reguler, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_right")
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: "https://team-sole.notion.site/37661e4412d345b8a5c2ce5a609e120b")!)
                    }
            }
            
            HStack(spacing: 14.0) {
                Image(viewStore.isSelectedForthTerm
                      ? "check_circle"
                      : "radio_button_unchecked")
                .onTapGesture {
                    viewStore.send(.didTappedForthTerm)
                }
                Text(StringConstant.terms4ForSignUp)
                    .font(.pretendard(.reguler, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_right")
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: "https://team-sole.notion.site/37661e4412d345b8a5c2ce5a609e120b")!)
                    }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16.0)
    }
    
    private var continueButton: some View {
        Text(StringConstant.continueAfterAgree)
            .foregroundColor(.white)
            .font(.pretendard(.medium, size: 16.0))
            .frame(maxWidth: .infinity,
                   alignment: .center)
            .frame(height: 48.0)
            .background(viewStore.isValidCheckingTerms
                        ? Color.blue_4708FA
                        : Color.gray_D3D4D5)
            .cornerRadius(8.0)
            .padding(.horizontal, 16.0)
            .padding(.bottom, 40.0)
            .contentShape(Rectangle())
    }
    
    private var navigateToSignUpUserInfoView: some View {
        NavigationLinkStore(store.scope(state: \.$signUpUserInfo, action: SignUpAgreeTermsFeature.Action.signUpUserInfo), onTap: {
            viewStore.send(.didTappedContinueButton)
        }, destination: { store in
            SignUpUserInfoView(viewModel: .init())
        }, label: {
            continueButton
        })
    }
}

struct SignUpFirstStepView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpAgreeTermsView(store: Store(initialState: SignUpAgreeTermsFeature.State(), reducer: { SignUpAgreeTermsFeature()}))
    }
}
