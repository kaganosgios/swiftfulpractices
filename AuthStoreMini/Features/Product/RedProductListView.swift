//
//  RedProductListView.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 7.02.2026.
//

import SwiftUI

struct RedProductListView: View {
    @StateObject private var vm = ModernProductListViewModel()
    @EnvironmentObject var network: NetworkMonitor
    
    var body: some View {
        ZStack {
            Color.red.opacity(0.1).ignoresSafeArea()
            
            if !network.isConnceted {
                VStack{
                    Image(systemName: "wifi.slash")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("İnternet bagantın yok ya bi check at")
                }
                
            }else{
                List(vm.products) { product in
                    Text(product.title)
                        .foregroundColor(.blue)
                        .padding()
                }
                
            }
            
           
            if vm.isLoading {
                ProgressView().tint(.cyan)
            }
            
            if let error = vm.errorMessage {
                Text(error).foregroundColor(.red)
            }
            
        }
        .task {
            if network.isConnceted {
                await vm.fetchProducts()
            }
              
        }
    }
}

#Preview {
    RedProductListView()
}
