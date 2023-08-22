//
//  AppView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/18.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var checkToken = true
    let store: StoreOf<AppFeature>
    
    init(store: StoreOf<AppFeature>) {
        self.store = store
    }
    
    var body: some View {
        SwitchStore(self.store) { state in
            switch state {
            case .signIn:
                CaseLet(/AppFeature.State.signIn, action: AppFeature.Action.signIn) {
                    SignInView(store: $0)
                }
            case .main:
                CaseLet(/AppFeature.State.main, action: AppFeature.Action.main) {
                    MainTabbarView(store: $0)
                }
                
            case .loading:
                CaseLet(/AppFeature.State.loading, action: AppFeature.Action.loading) {
                    IntroView(store: $0)
                }
            }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: Store(initialState: AppFeature.State(), reducer: { AppFeature() }))
    }
}
