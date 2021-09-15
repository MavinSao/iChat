//
//  User.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import Foundation

struct User: Codable {
    let id       : String?
    let username : String?
    let fullname : String?
    let email    : String?
    let avatar   : String?
    var dictionary: [String:Any] {
        return [
            "id"      : id ?? "",
            "username": username ?? "",
            "fullname": fullname ?? "",
            "email"   : email ?? "",
            "avatar"  : avatar ?? ""
        ]
    }
    
    init(id: String, username: String,fullname: String,email: String,avatar: String) {
        self.id = id
        self.username = username
        self.fullname = fullname
        self.email    = email
        self.avatar   = avatar
    }
    
}
