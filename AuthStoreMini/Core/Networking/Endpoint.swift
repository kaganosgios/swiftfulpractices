//
//  Endpoint.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 8.02.2026.
//

import Foundation

enum Endpoint{
    case products
    case profile
    
    var url:URL? {
        switch self {
        case .products:
            return URL(string: "https://dummyjson.com/products")
            
            case .profile:
            return URL(string: "https://dummyjson.com/auth/me")
        }
    }
    var requiresAuth: Bool {
         switch self {
         case .profile:
             return true
         default:
             return false
         }
     }
}
