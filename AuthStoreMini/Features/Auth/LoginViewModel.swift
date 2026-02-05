//
//  LoginViewModel.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 5.02.2026.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var errorMessage : String?
    
    func login(completion: @escaping (Bool) -> Void){
        isLoading = true
        
        let url = URL(string: "https://reqres.in/api/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                self.isLoading = false
                completion(data != nil)
            }
            
            
        }.resume()
    }
}
