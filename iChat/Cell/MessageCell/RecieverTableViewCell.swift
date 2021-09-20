//
//  RecieverTableViewCell.swift
//  iChat
//
//  Created by Mavin Sao on 16/9/21.
//

import UIKit

class RecieverTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTextLabel: SSPaddingLabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var imageURL: UIImageView!
    @IBOutlet weak var mediaHeight: NSLayoutConstraint!
    @IBOutlet weak var spacingMedia: NSLayoutConstraint!
    
    func config(message: Message) {
           
        var avatarURL = "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png"
        if let avatar = message.senderAvatar{
            if avatar != ""{
                avatarURL = avatar
            }
        }
        
        if message.mediaURL != "" {
            let mediaURL = URL(string: message.mediaURL! )
            self.imageURL.kf.setImage(with: mediaURL)
            self.mediaHeight.constant = 250
            self.spacingMedia.constant = 10
            self.layoutIfNeeded()
        }else{
            self.spacingMedia.constant = 2
            self.mediaHeight.constant = 2
            self.imageURL.image = UIImage()
            self.layoutIfNeeded()
        }
        
        let profileURL = URL(string: avatarURL )
        
        self.profileImage.kf.setImage(with: profileURL)
        self.messageTextLabel.text = message.messageText

            self.messageTextLabel.padding = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
            self.messageTextLabel.sizeToFit()
            self.messageTextLabel.layer.cornerRadius = 25
            self.messageTextLabel.layer.masksToBounds = true

    }
    
}
