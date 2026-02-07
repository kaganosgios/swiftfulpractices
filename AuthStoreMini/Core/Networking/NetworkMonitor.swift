//
//  NetworkMonitor.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 9.02.2026.
//

import Foundation
import Combine
import Network



final class NetworkMonitor : ObservableObject{
    static let shared = NetworkMonitor()
    
    @Published var isConnceted: Bool = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private init() {
        monitor.pathUpdateHandler = { path in
            self.isConnceted = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    
}


/*
 @Published var isConnected: Bu bir hoparlör gibidir. İnternet durumu değiştiği anda (True/False), bu değişkeni dinleyen tüm SwiftUI arayüzlerine "Hey, durum değişti, kendini güncelle!" haberini gönderir.

 NWPathMonitor(): Apple'ın bize sunduğu asıl "radar" cihazıdır. Kablo takıldı mı, Wi-Fi koptu mu diye ağ yollarını (path) sürekli tarar.

 DispatchQueue(label: "NetworkMonitor"): İnterneti takip etmek zahmetli bir iştir. Uygulamanın ana ekranını (UI) dondurmamak için bu işi arka planda çalışan özel bir sıraya (queue) atıyoruz.
 
 */
