//
//  RoomTableViewCell.swift
//  iChat
//
//  Created by Mavin on 9/16/21.
//

import UIKit
import Kingfisher

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var defaults = UserDefaults.standard
    
    func config(room: PrivateRoom){
        let currID = defaults.string(forKey: "currentID")
        
 
        
        var avatarURLOne = "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png"
        var avatarURLTwo = "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png"
        
        if let avatarOne =  room.userOneAvatar, let avatarTwo = room.userTwoAvatar{
            if avatarOne != ""{
                avatarURLOne = avatarOne
            }
            if avatarTwo != ""{
                avatarURLTwo = avatarTwo
            }
        }
        
        let pfURLOne = URL(string: avatarURLOne)
        let pfURLTwo = URL(string: avatarURLTwo)
        
        if room.membersId![0] == currID {
            self.usernameLabel.text = room.userTwoName
            self.profileImage.kf.setImage(with: pfURLTwo)
        }else{
            self.usernameLabel.text = room.userOneName
            self.profileImage.kf.setImage(with: pfURLOne)
        }
        self.messageLabel.text = room.lastMessage
        
    }
    
    
}
