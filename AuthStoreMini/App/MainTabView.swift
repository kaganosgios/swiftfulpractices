//
//  MainTabView.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 7.02.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
       TabView {
            ProductListView()
               .tabItem {
                   Label("default", systemImage: "list.bullet")
               }
           
           RedProductListView()
               .tabItem {
                   Label("redList", systemImage: "flame.fill")
               }
           
           ProfileView()
                  .tabItem { Label("Profile", systemImage: "person.fill") }
        }
    }
}

#Preview {
    MainTabView()
}
