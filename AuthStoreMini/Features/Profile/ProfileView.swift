//
//  ProfileView.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 8.02.2026.
//

import Foundation
import Combine
import SwiftUI


struct ProfileView: View {
    @StateObject private var vm = ProfileViewModel()
    @EnvironmentObject var coordinator: AppCoordinator


    var body: some View {
        VStack(spacing: 16) {
            if vm.isLoading {
                ProgressView()
            }

            if let error = vm.errorMessage {
                Text(error).foregroundColor(.red)
            }

            Text("Username: \(vm.username)")
                .padding()
            
            
            Button("Logout") {
                           vm.logout()
                           coordinator.isAuthenticated = false
                       }
                       .foregroundColor(.red)
                       .padding()
        }
        .task {
            await vm.fetchProfile()
        }
    }
}
