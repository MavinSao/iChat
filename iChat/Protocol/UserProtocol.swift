//
//  UserProtocol.swift
//  iChat
//
//  Created by Mavin Sao on 16/9/21.
//

import Foundation

protocol UserProtocolDelegate {
    func didSent(recievedUser: User)
    func joinChat(room: PrivateRoom, recieverId: String)
}
