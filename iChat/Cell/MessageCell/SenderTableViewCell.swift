//
//  SenderTableViewCell.swift
//  iChat
//
//  Created by Mavin Sao on 16/9/21.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var imageURL: UIImageView!
    @IBOutlet weak var messageText: SSPaddingLabel!
    
    @IBOutlet weak var spacingMedia: NSLayoutConstraint!
    
    @IBOutlet weak var messageHeight: NSLayoutConstraint!
    @IBOutlet weak var mediaHeight: NSLayoutConstraint!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(message: Message) {

        var avatarURL = "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png"
        if let avatar = message.senderAvatar{
            if avatar != ""{
                avatarURL = avatar
            }
        }
        if message.mediaURL != "" {
            let mediaURL = URL(string: message.mediaURL!)
            self.imageURL.kf.setImage(with: mediaURL)
            self.spacingMedia.constant = 10
            self.mediaHeight.constant = 250
        }else{
            self.spacingMedia.constant = 2
            self.mediaHeight.constant = 0
            self.imageURL.image = UIImage()
        }
        
        let profileURL = URL(string: avatarURL )
        
        self.profileImage.kf.setImage(with: profileURL)
        self.messageText.text = message.messageText
        self.messageText.layer.cornerRadius = 25
        self.messageText.layer.masksToBounds = true
        
        if message.messageText != ""{
            self.messageHeight.constant = 50
            self.messageText.padding = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
            self.messageText.isHidden = false
         }else{
            self.messageHeight.constant = 0
            self.messageText.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.messageText.isHidden = true
         }
        self.layoutIfNeeded()
        self.messageText.sizeToFit()
       
    }
    
 
    
}
