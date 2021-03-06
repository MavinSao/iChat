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
    @IBOutlet weak var sendDate: UILabel!
    
    var defaults = UserDefaults.standard
    
    func config(room: PrivateRoom){
        let currID = defaults.string(forKey: "currentID")

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat  = "EEEE" // "EE" to get short style
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        
        let date = dayFormatter.string(from: room.sendDate!)
        let time = timeFormatter.string(from: room.sendDate!)
        
        self.sendDate.text = "\(date). \(time)"
        
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
            
            if room.isUserOneSeen! {
                self.backgroundColor = .white
            }else{
                self.backgroundColor = .systemGray6
            }
            
        }else{
            print("roomUserTwo",room)
            self.usernameLabel.text = room.userOneName
            self.profileImage.kf.setImage(with: pfURLOne)
            
            if room.isUserTwoSeen! {
                self.backgroundColor = .white
            }else{
                self.backgroundColor = .systemGray6
            }
        }
        
        self.messageLabel.text = room.lastMessage
   
    }
    
    
}
