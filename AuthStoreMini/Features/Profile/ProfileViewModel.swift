//
//  ProfileViewModel.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 8.02.2026.
//

import Foundation
import Combine


@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var username: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            let profile: ProfileResponse = try await APIClient.request(.profile)
            username = profile.username
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
    
    func logout() {
          AuthManager.shared.logout()
      }
}

struct ProfileResponse: Decodable {
    let username: String
}
