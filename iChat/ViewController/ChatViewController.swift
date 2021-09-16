//
//  ChatViewController.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import UIKit
import ProgressHUD

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var userDelegate: UserProtocolDelegate?
    
    var roomData: [PrivateRoom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "RoomTableViewCell", bundle: nil), forCellReuseIdentifier: "chatCell")
        fetchAllChats()
        
        
    }
    
    func fetchAllChats(){
        ChatService.shared.fetchAllChatRoom { result in
            switch result {
            case .success(let rooms):
                   self.roomData=rooms
                   self.tableView.reloadData()
            case .failure(let err):
                   ProgressHUD.showError(err.localizedDescription)
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
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

extension ChatViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        roomData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currId = UserDefaults.standard.string(forKey: "currentID")
        let roomVC = storyboard?.instantiateViewController(identifier: "roomVC") as! RoomViewController

        let reciverId = roomData[indexPath.row].membersId?.filter({ uid in
            uid != currId
        })

        let roomObj = roomData[indexPath.row]
        print(roomObj)

        guard let safeReciverId = reciverId else {return}

        self.userDelegate = roomVC
        userDelegate?.joinChat(room: roomObj, recieverId: safeReciverId[0])
        
        self.navigationController?.pushViewController(roomVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! RoomTableViewCell
        cell.selectionStyle = .none
        cell.config(room: roomData[indexPath.row])
        
        return cell
        
    }

}




