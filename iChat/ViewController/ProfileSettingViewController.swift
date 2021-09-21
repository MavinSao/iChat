//
//  ProfileSettingViewController.swift
//  iChat
//
//  Created by Mavin Sao on 18/9/21.
//

import UIKit
import ProgressHUD

class ProfileSettingViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
//    var settings : [String:[Setting]] = [:]
    var settings : [[Setting]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableview.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "settingCell")
        setUpSettings()
        getCurrentUser()
    }
    
    func setUpSettings() {
        let darkMode = Setting(title: "Dark Mode", image: "moon", segueIden: "", backColor: .darkGray)
        let profileSet = Setting(title: "Update Infomation", image: "person", segueIden: "", backColor: .orange)
        let activeStatus = Setting(title: "Active Status", image: "active", segueIden: "", backColor: .brown)
        let archived = Setting(title: "Archived Chat", image: "archive", segueIden: "", backColor: .systemGray2)
        let notification = Setting(title: "Notification and Sound", image: "bell", segueIden: "", backColor: .blue)
        let accountSetting = Setting(title: "Account Settings", image: "setting", segueIden: "", backColor: .systemGray3)
        let logout = Setting(title: "Logout", image: "logout", segueIden: "", backColor: .red)
        
        self.settings = [[darkMode,profileSet,activeStatus,archived],[notification],[accountSetting,logout]]
//        self.settings = ["General":[darkMode,profileSet,activeStatus,archived],"PREFERENCE":[notification],"ACCOUNT & SUPPORT":[accountSetting,logout]]
        
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
    
    func logout(){
        let appDelegate = UIApplication.shared.windows.first
        let loginVC = storyboard?.instantiateViewController(identifier: "LoginVC")
        
        AuthService.shared.logout { result in
            switch result{
                case .success(let isSucc):
                    if(isSucc){appDelegate?.rootViewController = loginVC}
                case .failure(let err):
                    ProgressHUD.showError(err.localizedDescription)
            }
        }
    }

}

extension ProfileSettingViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.settings.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "GENERAL"
        case 1:
            return "PREFERENCE"
        case 2:
            return "ACCOUNT & SUPPORT"
        default:
            return "Default"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell
        cell.selectionStyle = .none
        let section = self.settings[indexPath.section]
        let item = section[indexPath.row]
        cell.config(item: item)

    
        return cell
    }
}
extension ProfileSettingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2{
            switch indexPath.row {
            case 0:
                print("setting")
            case 1:
                self.logout()
            default:
                print("default",indexPath.row)
            }
        }
        
    }
}
