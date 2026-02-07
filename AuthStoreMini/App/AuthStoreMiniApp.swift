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
    @StateObject var networkMonitor = NetworkMonitor.shared
    var body: some Scene {
        WindowGroup {
            if coordinator.isAuthenticated{
               MainTabView()
            }else{
                LoginView()
            }
        }
        .environmentObject(coordinator)
        .environmentObject(networkMonitor)
    }
}
