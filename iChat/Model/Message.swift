//
//  Message.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import Foundation

struct Message {
    var roomIdentifier  : String?
    var senderId        : String?
    var senderName      : String?
    var senderAvatar    : String?
    var recieverId      : String?
    var recieverName    : String?
    var recieverAvatar  : String?
    var sendDate        : Date?
    var messageText     : String?
    var mediaURL        : String?
    var status          : Bool?
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
            "status" : status ?? "",
        ]
    }
    
}
