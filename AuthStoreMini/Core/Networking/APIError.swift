//
//  APIError.swift
//  AuthStoreMini
//
//  Created by KağanKAPLAN on 8.02.2026.
//

import Foundation

enum APIError: Error{
    case invalidURL
    case decoding
    case network(Error)
}
