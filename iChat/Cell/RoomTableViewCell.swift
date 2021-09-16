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
        
        let pfURLOne = URL(string: room.userOneAvatar!)
        let pfURLTwo = URL(string: room.userOneAvatar!)
        
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
