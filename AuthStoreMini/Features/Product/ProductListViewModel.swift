//
//  ProductListViewModel.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 5.02.2026.
//

import Foundation
import Combine
import SwiftUI

struct Product: Decodable, Identifiable {
    let id: Int
    let title: String
}

final class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchProducts() {
        isLoading = true
        errorMessage = nil

        let url = URL(string: "https://dummyjson.com/products")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(Response.self, from: data)
                    self.products = decoded.products
                } catch {
                    self.errorMessage = "Failed to decode data"
                }
            }
        }.resume()
    }

    struct Response: Decodable {
        let products: [Product]
    }
}
