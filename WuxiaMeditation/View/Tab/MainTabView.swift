//
//  Tab.swift
//  운기조식
//
//  Created by Austin's Macbook Pro M3 on 8/25/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("운기조식", systemImage: "aqi.medium")
                }
            RankingView()
                .tabItem {
                    Label("고수 랭킹", systemImage: "person.3.fill")
                }
            SettingView()
                .tabItem {
                    Label("설정", systemImage: "person.and.background.striped.horizontal")
                }
        }
    }
}

#Preview {
    MainTabView()
}
