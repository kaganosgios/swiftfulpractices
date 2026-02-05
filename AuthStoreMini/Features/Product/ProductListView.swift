//
//  ProductListView.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 5.02.2026.
//

import Foundation
import SwiftUI

struct ProductListView: View {
    @StateObject var vm = ProductListViewModel()
    var body: some View {
        VStack{
            List(vm.products) { product in
                Text(product.title)
                    .padding()
            }
        }
        .onAppear{
            vm.fetchProducts()
            
        }
        
       
    }
}
