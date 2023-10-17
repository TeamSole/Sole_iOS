//
//  MainTabbarView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/13.
//

import SwiftUI
import ComposableArchitecture


struct MainTabbarView: View {
//    @EnvironmentObject var mainViewModel: MainViewModel
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
            TabView(selection: viewStore.binding(get: \.selectedTab,
                                                 send: MainFeature.Action.selectTab)) {
                HomeView(store: self.store.scope(state: \.home, action: MainFeature.Action.home))
//                    .environmentObject(mainViewModel)
                    .tabItem {
                        viewStore.selectedTab == .HOME ? Image("home_tap_selected") : Image("home_tap")
                        Text(StringConstant.tabHome)
                    }
                    .tag(MainFeature.Tab.HOME)
                
                HistoryView(store: self.store.scope(state: \.history, action: MainFeature.Action.history))
                    .tabItem {
                        viewStore.selectedTab == .HISTORY ? Image("history_tap_selected") : Image("history_tap")
                        Text(StringConstant.tabHistory)
                    }
                    .tag(MainFeature.Tab.HISTORY)
                
                FollowingBoardView(store: self.store.scope(state: \.follow, action: MainFeature.Action.follow))
                    .tabItem {
                        viewStore.selectedTab == .FOLLOWING ? Image("following_tap_selected") : Image("following_tap")
                        Text(StringConstant.tabFollowing)
                    }
                    .tag(MainFeature.Tab.FOLLOWING)
                
                ScrapFolderView(store: Store(initialState: ScrapFolderFeature.State(), reducer: { ScrapFolderFeature() }))
//                ScrapFolderView(store: self.store.scope(state: \.scrap, action: MainFeature.Action.scrap))
                    .tabItem {
                        viewStore.selectedTab == .SCRAP ? Image("scrap_tap_selected") : Image("scrap_tap")
                        Text(StringConstant.tabScrap)
                    }
                    .tag(MainFeature.Tab.SCRAP)
            }
            .accentColor(Color(UIColor.blue_4708FA))
        }
        .navigationViewStyle(.stack)
    }
}

struct MainTabbarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbarView(store: Store(initialState: MainFeature.State(), reducer: { MainFeature() }))
            .environmentObject(MainViewModel())
    }
}
