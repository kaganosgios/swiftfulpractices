//
//  LoginViewModel.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 5.02.2026.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {

    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    func login(completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil

        let url = URL(string: "https://dummyjson.com/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "username": username,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false

                guard let data else {
                    self.errorMessage = error?.localizedDescription
                    completion(false)
                    return
                }

                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    
                    TokenStore.shared.token = response.accessToken
                
                    
                    completion(true)
                } catch {
                    self.errorMessage = "Login decode error"
                    completion(false)
                }
            }
        }.resume()
    }
}


/*
 test için
 "username": "emilys",
       "password": "emilyspass",
 */
