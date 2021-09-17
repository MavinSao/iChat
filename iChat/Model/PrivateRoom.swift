//
//  ChatRoom.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import Foundation

struct PrivateRoom {
    let roomIdentifier : String?
    let membersId      : [String]?
    let lastMessage    : String?
    let isSeen         : Bool?
    let userOneName    : String?
    let userOneAvatar  : String?
    let userTwoName    : String?
    let userTwoAvatar  : String?
    let isUserOneTyping  : Bool?
    let isUserTwoTyping  : Bool?
    
    var dictionary: [String:Any] {
        return [
            "roomIdentifier" : roomIdentifier ?? "",
            "membersId" : membersId ?? [],
            "lastMessage" : lastMessage ?? "",
            "isSeen" : isSeen ?? "",
            "userOneName": userOneName ?? "",
            "userOneAvatar" : userOneAvatar ?? "",
            "userTwoName": userTwoName ?? "",
            "userTwoAvatar": userTwoAvatar ?? "",
            "isUserOneTyping": isUserOneTyping ?? false,
            "isUserTwoTyping": isUserTwoTyping ?? false
            
        ]
    }
}

