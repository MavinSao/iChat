//
//  UserTableViewCell.swift
//  iChat
//
//  Created by Mavin Sao on 16/9/21.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    func config(user: User){
        let profileURL = URL(string: user.avatar ?? "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png")
        self.profileImage.kf.setImage(with: profileURL)
        self.usernameLabel.text = user.username
        self.emailLabel.text = user.email
    }

    
}
