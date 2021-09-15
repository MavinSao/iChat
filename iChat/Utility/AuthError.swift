//
//  AuthError.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import Foundation

enum AuthError: Error {
    case notRegister
    case userNotFound
    
    var description: String {
        switch self {
        case .notRegister:
            return "Not yet register"
        case .userNotFound:
            return "User not found"
        default:
            return ""
        }
    }
    
}
