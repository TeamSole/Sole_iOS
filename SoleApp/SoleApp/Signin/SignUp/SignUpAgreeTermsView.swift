//
//  SignUpAgreeTermsView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/15.
//

import SwiftUI

struct SignUpAgreeTermsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: SignUpViewModel
    
    @State private var showSignUpUserInfoView: Bool = false
    var body: some View {
        VStack(spacing: 0.0) {
            navigationBar
            descriptionView
            allCheckBoxView
            checkTermsView
            continueButton
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
                    presentationMode.wrappedValue.dismiss()
                }
            Text("회원가입")
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
            Text("안녕하세요.\n지도 위의 발자국, SOLE입니다.")
                .foregroundColor(.black)
                .font(.pretendard(.bold, size: 16.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .padding(.vertical, 36.0)
            Text("회원가입을 위해 약관에 동의해주세요.")
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
                Image(viewModel.isSelectedAllTerms
                      ? "check_circle"
                      : "radio_button_unchecked")
                    .onTapGesture {
                        viewModel.didTapCheckAllTerms()
                    }
                Text("약관 전체 동의")
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
                Image(viewModel.isSelectedFirstTerm
                      ? "check_circle"
                      : "radio_button_unchecked")
                .onTapGesture {
                    viewModel.isSelectedFirstTerm.toggle()
                }
                Text("서비스 이용약관 동의 (필수)")
                    .font(.pretendard(.reguler, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_right")
            }
            
            HStack(spacing: 14.0) {
                Image(viewModel.isSelectedSecondTerm
                      ? "check_circle"
                      : "radio_button_unchecked")
                .onTapGesture {
                    viewModel.isSelectedSecondTerm.toggle()
                }
                Text("개인정보 처리방침 동의 (필수)")
                    .font(.pretendard(.reguler, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_right")
            }
            
            HStack(spacing: 14.0) {
                Image(viewModel.isSelectedThirdTerm
                      ? "check_circle"
                      : "radio_button_unchecked")
                .onTapGesture {
                    viewModel.isSelectedThirdTerm.toggle()
                }
                Text("마케팅 정보 제공 및 수신 동의 (선택)")
                    .font(.pretendard(.reguler, size: 16.0))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                Image("arrow_right")
            }
            
            Spacer()
        }
        .padding(.horizontal, 16.0)
    }
    
    private var continueButton: some View {
        Text("동의하고 계속하기")
            .foregroundColor(.white)
            .font(.pretendard(.medium, size: 16.0))
            .frame(maxWidth: .infinity,
                   alignment: .center)
            .frame(height: 48.0)
            .background(viewModel.isValidCheckingTerms
                        ? Color.blue_4708FA
                        : Color.gray_D3D4D5)
            .cornerRadius(8.0)
            .padding(.horizontal, 16.0)
            .padding(.bottom, 40.0)
            .contentShape(Rectangle())
            .onTapGesture {
                guard viewModel.isValidCheckingTerms else { return }
                viewModel.setSignupData()
                showSignUpUserInfoView = true
            }
    }
    
    private var navigateToSignUpUserInfoView: some View {
        NavigationLink(destination:
                        SignUpUserInfoView(viewModel: viewModel),
                       isActive: $showSignUpUserInfoView,
                       label: {
            EmptyView()
        })
    }
}

struct SignUpFirstStepView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpAgreeTermsView(viewModel: .init())
    }
}
