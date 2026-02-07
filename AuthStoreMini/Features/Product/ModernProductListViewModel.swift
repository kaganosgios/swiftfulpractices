//
//  ModernProductListViewModel.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 7.02.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ModernProductListViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: ProductResponse = try await APIClient.request(.products)
            products = response.products
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }


    struct ProductResponse: Decodable {
        let products: [Product]
    }
}

