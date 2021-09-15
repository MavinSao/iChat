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
    var dictionary: [String:Any] {
        return [
            "roomIdentifier" : roomIdentifier ?? "",
            "membersId" : membersId ?? [],
            "lastMessage" : lastMessage ?? "",
            "isSeen" : isSeen ?? "",
        ]
    }
}

