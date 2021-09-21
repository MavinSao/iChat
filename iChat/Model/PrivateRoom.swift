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
    let sendDate       : Date?
    let userOneName    : String?
    let userOneAvatar  : String?
    let userTwoName    : String?
    let userTwoAvatar  : String?
    let isUserOneTyping  : Bool?
    let isUserTwoTyping  : Bool?
    let isUserOneSeen  : Bool?
    let isUserTwoSeen  : Bool?
    
    var dictionary: [String:Any] {
        return [
            "roomIdentifier" : roomIdentifier ?? "",
            "membersId" : membersId ?? [],
            "lastMessage" : lastMessage ?? "",
            "isSeen" : isSeen ?? "",
            "sendDate": sendDate ?? Date(),
            "userOneName": userOneName ?? "",
            "userOneAvatar" : userOneAvatar ?? "",
            "userTwoName": userTwoName ?? "",
            "userTwoAvatar": userTwoAvatar ?? "",
            "isUserOneTyping": isUserOneTyping ?? false,
            "isUserTwoTyping": isUserTwoTyping ?? false,
            "isUserOneSeen": isUserOneSeen ?? false,
            "isUserTwoSeen": isUserTwoSeen ?? false,
            
        ]
    }
}

