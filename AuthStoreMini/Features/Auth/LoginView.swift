//
//  LoginView.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 5.02.2026.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject var vm = LoginViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    var body: some View {
        VStack{
            TextField("Email", text: $vm.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $vm.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
           if vm.isLoading {
                ProgressView()
            }
            
            Button("Login"){
                vm.login { success in
                    if success {
                        coordinator.isAuthenticated = true
                    }
                }
            }
        }
        .padding()
    }
}
