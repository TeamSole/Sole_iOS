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
            VStack(spacing: 0.0) {
                VStack(spacing: 0.0) {
                    switch viewStore.selectedTab {
                    case .HOME:
                        HomeView(store: self.store.scope(state: \.home, action: MainFeature.Action.home))
                    case .HISTORY:
                        HistoryView(store: self.store.scope(state: \.history, action: MainFeature.Action.history))
                    case .FOLLOWING:
                        FollowingBoardView(store: self.store.scope(state: \.follow, action: MainFeature.Action.follow))
                    case .SCRAP:
                        ScrapFolderView(store: self.store.scope(state: \.scrap, action: MainFeature.Action.scrap))
                    }
                }
                VStack(spacing: 0) {
                    self.bottomArea
                        .padding(.top, 6)
                        .padding(.bottom, 4)
                }
                .frame(height: 50)
                .background(Rectangle()
                    .fill(Color.white))
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.notifyRefreshTokenExpired)) { _ in
                viewStore.send(.moveToSignIn)
            }
        }
        .navigationViewStyle(.stack)
//        NavigationView {
//            TabView(selection: viewStore.binding(get: \.selectedTab,
//                                                 send: MainFeature.Action.selectTab)) {
//                HomeView(store: self.store.scope(state: \.home, action: MainFeature.Action.home))
////                    .environmentObject(mainViewModel)
//                    .tabItem {
//                        viewStore.selectedTab == .HOME ? Image("home_tap_selected") : Image("home_tap")
//                        Text(StringConstant.tabHome)
//                    }
//                    .tag(MainFeature.Tab.HOME)
//                
//                HistoryView(store: self.store.scope(state: \.history, action: MainFeature.Action.history))
//                    .tabItem {
//                        viewStore.selectedTab == .HISTORY ? Image("history_tap_selected") : Image("history_tap")
//                        Text(StringConstant.tabHistory)
//                    }
//                    .tag(MainFeature.Tab.HISTORY)
//                
//                FollowingBoardView(store: self.store.scope(state: \.follow, action: MainFeature.Action.follow))
//                    .tabItem {
//                        viewStore.selectedTab == .FOLLOWING ? Image("following_tap_selected") : Image("following_tap")
//                        Text(StringConstant.tabFollowing)
//                    }
//                    .tag(MainFeature.Tab.FOLLOWING)
//                
//                ScrapFolderView(store: self.store.scope(state: \.scrap, action: MainFeature.Action.scrap))
//                    .tabItem {
//                        viewStore.selectedTab == .SCRAP ? Image("scrap_tap_selected") : Image("scrap_tap")
//                        Text(StringConstant.tabScrap)
//                    }
//                    .tag(MainFeature.Tab.SCRAP)
//            }
//            .accentColor(Color(UIColor.blue_4708FA))
//        }
//        .navigationViewStyle(.stack)
    }
}

extension MainTabbarView {
    private var bottomArea: some View {
        HStack(spacing: 0.0) {
            self.bottomItemButton(icon:   viewStore.selectedTab == .HOME ? Image("home_tap_selected") : Image("home_tap"),
                                  title:   StringConstant.tabHome,
                                  isHilighted: viewStore.selectedTab == .HOME,
                                  action: {
                viewStore.send(.selectTab(.HOME))
            })
            .frame(maxWidth:. infinity)
            self.bottomItemButton(icon:     viewStore.selectedTab == .HISTORY ? Image("history_tap_selected") : Image("history_tap"),
                                  title:    StringConstant.tabHistory,
                                  isHilighted: viewStore.selectedTab == .HISTORY,
                                  action: {
                viewStore.send(.selectTab(.HISTORY))

            })
            .frame(maxWidth:. infinity)
            self.bottomItemButton(icon:    viewStore.selectedTab == .FOLLOWING ? Image("following_tap_selected") : Image("following_tap"),
                                  title:   StringConstant.tabFollowing,
                                  isHilighted: viewStore.selectedTab == .FOLLOWING,
                                  action: {
                viewStore.send(.selectTab(.FOLLOWING))
            })
            .frame(maxWidth:. infinity)
            self.bottomItemButton(icon:    viewStore.selectedTab == .SCRAP ? Image("scrap_tap_selected") : Image("scrap_tap"),
                                  title:    StringConstant.tabScrap,
                                  isHilighted: viewStore.selectedTab == .SCRAP, action: {
                viewStore.send(.selectTab(.SCRAP))
            })
            .frame(maxWidth:. infinity)
        }
    }
    
    private func bottomItemButton(icon: Image,
                                  title: String,
                                  isHilighted: Bool,
                                  action: @escaping ()->Void) -> some View {
        Button(action: action) {
            VStack(spacing: 0.0) {
                ZStack(alignment: .center) {
                    icon
                        .foregroundColor(Color.gray)
                        .padding(.bottom, CGFloat/*SwiftUI Bug*/(title.isEmpty ? 0.0 : 4.0))
                }
                Text(title)
                    .font(.pretendard(.reguler, size: 10.0))
                    .foregroundColor(isHilighted ? .blue_4708FA : .gray_D6D6D6)
                    .isHidden(title.isEmpty, remove: true)
            }
        }
    }
}

struct MainTabbarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbarView(store: Store(initialState: MainFeature.State(), reducer: { MainFeature() }))
            .environmentObject(MainViewModel())
    }
}
