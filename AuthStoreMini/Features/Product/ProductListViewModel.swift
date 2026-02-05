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
    
    func fetchProducts() {
        let url = URL(string: "https://dummyjson.com/products")!
        
        URLSession.shared.dataTask(with: url){ data, _, _ in
            guard let data else { return }
            let decoded = try? JSONDecoder().decode(Response.self, from: data)
            
            DispatchQueue.main.async{
                self.products = decoded?.products ?? []
            }
            
        }.resume()
    }
    
    struct Response: Decodable {
        let products: [Product]
    }
}
