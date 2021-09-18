//
//  Message.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import Foundation

struct Message {
    let roomIdentifier  : String?
    let senderId        : String?
    let senderName      : String?
    var senderAvatar    : String?
    let recieverId      : String?
    let recieverName    : String?
    var recieverAvatar  : String?
    let sendDate        : Date?
    var messageText     : String?
    let mediaURL        : String?
    let status          : Bool?
    var isDefault       : Bool?
    
    var dictionary: [String:Any] {
        return [
            "roomIdentifier" : roomIdentifier ?? "",
            "senderId" : senderId ?? "",
            "senderName" : senderName ?? "",
            "senderAvatar" : senderAvatar ?? "",
            "recieverId" : recieverId ?? "",
            "recieverName" : recieverName ?? "",
            "recieverAvatar" : recieverAvatar ?? "",
            "messageText"     : messageText ?? "",
            "sendDate" : sendDate ?? Date().timeIntervalSince1970,
            "mediaURL" : mediaURL ?? "",
            "isDefault" : isDefault ?? false,
            "status" : status ?? "",
        ]
    }
    
}
