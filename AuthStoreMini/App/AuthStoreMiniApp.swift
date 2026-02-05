//
//  AuthStoreMiniApp.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 5.02.2026.
//

import SwiftUI
import Combine

@main
struct AuthStoreMiniApp: App {
    
    @StateObject var coordinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            if coordinator.isAuthenticated{
               ProductListView()
            }else{
                LoginView()
            }
        }
        .environmentObject(coordinator)
    }
}
