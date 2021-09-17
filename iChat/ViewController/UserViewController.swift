//
//  UserViewController.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import UIKit
import ProgressHUD

class UserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userDelegate: UserProtocolDelegate?
    
    
    
    var allUsers: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userCell")
        fetchAllUser()
    }
    
    func fetchAllUser() {
        let currentId = UserDefaults.standard.string(forKey: "currentID")
        UserService.shared.fetchAllUsers { [self] result in
            switch result {
            case .success(let users):
                let allUsers = users.filter { user in
                    user.id != currentId
                }
                
                self.allUsers = allUsers
                self.tableView.reloadData()
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    
}

extension UserViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        cell.selectionStyle = .none
        cell.config(user: allUsers[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let roomVc = storyboard?.instantiateViewController(identifier: "roomVC") as! RoomViewController
        
        let withUser = allUsers[indexPath.row]
        
          ProgressHUD.animationType = .horizontalCirclesPulse
          ProgressHUD.animationType = .circleRotateChase
          ProgressHUD.show()
        
          ChatService.shared.createRoom(withUser: withUser) { result in
            switch result {
            case .success(let room):
                 print("The Room",room)
                self.userDelegate = roomVc
                self.userDelegate?.joinChat(room: room, recieverId: withUser.id!)
                ProgressHUD.dismiss()
                self.navigationController?.pushViewController(roomVc, animated: true)
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    

    
}
