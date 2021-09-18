//
//  ProfileSettingViewController.swift
//  iChat
//
//  Created by Mavin Sao on 18/9/21.
//

import UIKit

class ProfileSettingViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getCurrentUser()
    }
    
    func getCurrentUser(){
        let user = ChatService.shared.currentUser
        
        var avatarURL = "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png"
        if let avatar = user?.avatar{
            if avatar != ""{
                avatarURL = avatar
            }
        }
        let profileURL = URL(string: avatarURL)
        self.profileImage.kf.setImage(with: profileURL)
        self.usernameLabel.text = user?.fullname
        self.emailLabel.text = user?.email
        
        
    }

}
