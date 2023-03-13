//
//  MainTabbarView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/13.
//

import SwiftUI

struct MainTabbarView: View {
    @State private var selectedIndex: Int = 0
    init() {
        UITabBar.appearance().backgroundColor = .white
    }
    var body: some View {
        NavigationView {
            TabView(selection: $selectedIndex) {
                HomeView()
                    .tabItem {
                        selectedIndex == 0 ? Image("home_tap_selected") : Image("home_tap")
                        Text("홈")
                    }
                    .tag(0)
                HomeView()
                    .tabItem {
                        selectedIndex == 1 ? Image("history_tap_selected") : Image("history_tap")
                        Text("나의 기록")
                    }
                    .tag(1)
                FollowingBoardView()
                    .tabItem {
                        selectedIndex == 2 ? Image("following_tap_selected") : Image("following_tap")
                        Text("팔로잉")
                    }
                    .tag(2)
                HomeView()
                    .tabItem {
                        selectedIndex == 3 ? Image("scrap_tap_selected") : Image("scrap_tap")
                        Text("스크랩")
                    }
                    .tag(3)
            }
            .accentColor(Color(UIColor.blue_4708FA))
        }
    }
}

struct MainTabbarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbarView()
    }
}
