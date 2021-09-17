//
//  ChatViewController.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import UIKit
import ProgressHUD
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var userDelegate: UserProtocolDelegate?
    
    var roomData: [PrivateRoom] = []
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "RoomTableViewCell", bundle: nil), forCellReuseIdentifier: "chatCell")
        fetchAllPrivateRoom()
        
        
    }
    
//    func fetchAllChats(){
//        ChatService.shared.fetchAllChatRoom { result in
//            switch result {
//            case .success(let rooms):
//                   self.roomData=rooms
//                   self.tableView.reloadData()
//            case .failure(let err):
//                   ProgressHUD.showError(err.localizedDescription)
//            }
//        }
//    }
    
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
        cell.config(room: roomData[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
        
    }

}

extension ChatViewController{
    
    func fetchAllPrivateRoom(){
        do {
            // Create JSON Encoder
            let decoder = JSONDecoder()
            if let userData = UserDefaults.standard.data(forKey: "user"){
            let currentUser = try decoder.decode(User.self, from: userData)

                db.collection("PrivateRoom").whereField("membersId", arrayContains: currentUser.id!).addSnapshotListener({ snapshot, error in
                    if let error = error {
                        ProgressHUD.showError(error.localizedDescription)
                    }
                    guard let snapshot = snapshot else{
                        print("snapshot nil")
                        return
                    }
                    
                    var allRoom: [PrivateRoom] = []
                    
                    for document in snapshot.documents {
                        
                        let roomDic        = document.data()
                        let roomIdentifier = roomDic["roomIdentifier"] as! String
                        let lastMessage    = roomDic["lastMessage"] as! String
                        let isSeen         = roomDic["isSeen"] as! Bool
                        let membersId      = roomDic["membersId"] as! [String]
                        let userOneName    = roomDic["userOneName"] as! String
                        let userOneAvatar    = roomDic["userOneAvatar"] as! String
                        let userTwoName    = roomDic["userTwoName"] as! String
                        let userTwoAvatar    = roomDic["userTwoAvatar"] as! String
                        
                        let privateRoom = PrivateRoom(roomIdentifier: roomIdentifier, membersId: membersId, lastMessage: lastMessage, isSeen: isSeen, userOneName: userOneName, userOneAvatar: userOneAvatar, userTwoName: userTwoName, userTwoAvatar: userTwoAvatar, isUserOneTyping: false, isUserTwoTyping: false)
                        allRoom.append(privateRoom)
                    }
                    
                    DispatchQueue.main.async {
                        
                        let existRooms = allRoom.filter { room in
                            room.lastMessage != ""
                        }
                        self.roomData = existRooms
                        self.tableView.reloadData()
                    }
                    
                }
            )}
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
}




