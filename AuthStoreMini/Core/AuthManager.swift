//
//  AuthManager.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 5.02.2026.
//

import Foundation

final class AuthManager {
    static  let shared = AuthManager()
    private init() {}
    
    var token: String?
}
