//
//  IntroView.swift
//  SoleApp
//
//  Created by SUN on 2023/08/22.
//

import SwiftUI
import ComposableArchitecture

struct IntroView: View {
    private let store: StoreOf<IntroFeature>
    @ObservedObject var viewStore: ViewStoreOf<IntroFeature>
    
    init(store: StoreOf<IntroFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    var body: some View {
        VStack() {
            Image("sole_splash")
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .onAppear {
            viewStore.send(.checkExistToken)
        }
    }
}
