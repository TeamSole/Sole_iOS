//
//  IntroView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/18.
//

import SwiftUI
import ComposableArchitecture

struct IntroView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var checkToken = true
    var body: some View {
        VStack() {
            if checkToken {
                VStack() {
                    Image("sole_splash")
                }
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
            } else if mainViewModel.canShowMain && mainViewModel.existToken {
                VStack() {
                    MainTabbarView(store: Store(initialState: MainFeature.State(), reducer: { MainFeature() }))
                        .environmentObject(mainViewModel)
                }
            } else {
                VStack() {
                    SignInView(store: Store(initialState: SignInFeature.State(), reducer: { SignInFeature() }))
                }
                
            }
        }
        .onAppear {
            if Utility.load(key: Constant.token).isEmpty {
                self.mainViewModel.canShowMain = false
                self.mainViewModel.existToken = false
                checkToken = false
                
            } else {
                self.mainViewModel.canShowMain = true
                self.mainViewModel.existToken = true
                checkToken = false
            }
        }
        
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
