//
//  RecieverTableViewCell.swift
//  iChat
//
//  Created by Mavin Sao on 16/9/21.
//

import UIKit

class RecieverTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTextLabel: PaddingLabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    func config(message: Message) {
        
        let profileURL = URL(string: message.recieverAvatar ?? "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png")
        self.profileImage.kf.setImage(with: profileURL)
        self.messageTextLabel.text = message.messageText
        
    }
    
}
