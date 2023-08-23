//
//  MainTabbarView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/13.
//

import SwiftUI
import ComposableArchitecture


struct MainTabbarView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var selectedIndex: Int = 0
    
    private let store: StoreOf<MainFeature>
    @ObservedObject var viewStore: ViewStoreOf<MainFeature>
    
    init(store: StoreOf<MainFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedIndex) {
                HomeView()
                    .environmentObject(mainViewModel)
                    .tabItem {
                        selectedIndex == 0 ? Image("home_tap_selected") : Image("home_tap")
                        Text(StringConstant.tabHome)
                    }
                    .tag(0)
                HistoryView()
                    .tabItem {
                        selectedIndex == 1 ? Image("history_tap_selected") : Image("history_tap")
                        Text(StringConstant.tabHistory)
                    }
                    .tag(1)
                FollowingBoardView()
                    .tabItem {
                        selectedIndex == 2 ? Image("following_tap_selected") : Image("following_tap")
                        Text(StringConstant.tabFollowing)
                    }
                    .tag(2)
                ScrapFolderView()
                    .tabItem {
                        selectedIndex == 3 ? Image("scrap_tap_selected") : Image("scrap_tap")
                        Text(StringConstant.tabScrap)
                    }
                    .tag(3)
            }
            .accentColor(Color(UIColor.blue_4708FA))
        }
    }
}

struct MainTabbarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbarView(store: Store(initialState: MainFeature.State(), reducer: { MainFeature() }))
    }
}
