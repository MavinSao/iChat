//
//  SenderTableViewCell.swift
//  iChat
//
//  Created by Mavin Sao on 16/9/21.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageText: SSPaddingLabel!
    
    func config(message: Message) {
        
        var avatarURL = "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png"
        if let avatar = message.senderAvatar{
            if avatar != ""{
                avatarURL = avatar
            }
        }
        let profileURL = URL(string: avatarURL )
        
        self.profileImage.kf.setImage(with: profileURL)
        self.messageText.text = message.messageText
        
        self.messageText.padding = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        self.messageText.sizeToFit()
        self.messageText.layer.cornerRadius = 25
        self.messageText.layer.masksToBounds = true
    }
    
}
