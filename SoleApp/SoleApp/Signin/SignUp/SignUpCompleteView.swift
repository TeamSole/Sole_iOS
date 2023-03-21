//
//  SignUpCompleteView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/16.
//

import SwiftUI

struct SignUpCompleteView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @ObservedObject var viewModel: SignUpViewModel
    @State private var rotateDegree: Double = 10.0
    var body: some View {
        VStack(spacing: 0.0) {
            completeDescriptionView
            logoView
        }
        .navigationBarHidden(true)
        .onAppear {
//            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
//                rotateDegree = rotateDegree == 10 ? -10 : 10
//            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                
//                mainViewModel.existToken = true
//                mainViewModel.canShowMain = true
                mainViewModel.isFirstSignUp = true
                let window = UIApplication
                            .shared
                            .connectedScenes
                            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                            .first { $0.isKeyWindow }

                        window?.rootViewController = UIHostingController(rootView: IntroView()
                            .environmentObject(mainViewModel))
                        window?.makeKeyAndVisible()
                NavigationUtil.popToRootView()
            }
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
            VStack() {
                Image("onlyLogo")
            }
//            .rotationEffect(.degrees(rotateDegree))
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
    }
}

struct NavigationUtil {
  static func popToRootView() {
    findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
      .popToRootViewController(animated: true)
  }

  static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
    guard let viewController = viewController else {
      return nil
    }

    if let navigationController = viewController as? UINavigationController {
      return navigationController
    }

    for childViewController in viewController.children {
      return findNavigationController(viewController: childViewController)
    }

    return nil
  }
}

struct SignUpCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpCompleteView(viewModel: .init())
    }
}
