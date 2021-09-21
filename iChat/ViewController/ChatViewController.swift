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
    @IBOutlet weak var profileBarButton: UIBarButtonItem!
    
    var roomData: [PrivateRoom] = []
    let currentId = UserDefaults.standard.string(forKey: "currentID")
    
   
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "RoomTableViewCell", bundle: nil), forCellReuseIdentifier: "chatCell")
        fetchAllPrivateRoom()
        setInfo()
        print("view did load")
    }
    
    func setInfo() {
        let user = ChatService.shared.currentUser
        
        var avatarURL = "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png"
        if let avatar = user?.avatar{
            if avatar != ""{
                avatarURL = avatar
            }
        }
        let profileURL = URL(string: avatarURL)
        do{
            let imgData = try Data(contentsOf: profileURL!)
            let button = UIButton(type: .custom)
            
            button.setImage(UIImage(data: imgData), for: .normal)
//            self.profileBarButton.customView = button
            self.navigationController?.navigationItem.setRightBarButton(UIBarButtonItem(customView: button), animated: true)
            
        }catch let error{
            print(error.localizedDescription)
        }
       
    }
    
      
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.roomData.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let deleteId = roomData[indexPath.row].roomIdentifier
        guard let safeDeleteId = deleteId else {
            return
        }
        if editingStyle == .delete {
            
           
            print("=>start remove")
            
            print("=>start delete ui")
            self.roomData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
//            ChatService.shared.deleteAllMessageByRoom(roomId: safeDeleteId)
            ChatService.shared.deleteChatRoom(roomId: safeDeleteId)
            
            print("=>done")

        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }

        let currId = UserDefaults.standard.string(forKey: "currentID")
        let reciverId = roomData[indexPath.row].membersId?.filter({ uid in
            uid != currId
        })

        let roomObj = roomData[indexPath.row]

        guard let safeReciverId = reciverId else {return}

        let roomVc = segue.destination as? RoomViewController
        self.userDelegate = roomVc
        userDelegate?.joinChat(room: roomObj, recieverId: safeReciverId[0])

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currId = UserDefaults.standard.string(forKey: "currentID")
        let roomVC = storyboard?.instantiateViewController(identifier: "roomVC") as! RoomViewController

        let reciverId = roomData[indexPath.row].membersId?.filter({ uid in
            uid != currId
        })

        let roomObj = roomData[indexPath.row]

        guard let safeReciverId = reciverId else {return}

        self.userDelegate = roomVC
        userDelegate?.joinChat(room: roomObj, recieverId: safeReciverId[0])
//          performSegue(withIdentifier: "fromRoom", sender: self)
        
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
                        
                        print("snapshot=>",document.data())
                        
                        let roomDic        = document.data()
                        let roomIdentifier = roomDic["roomIdentifier"] as! String
                        let lastMessage    = roomDic["lastMessage"] as! String
                        let isSeen         = roomDic["isSeen"] as! Bool
                        let stamp          = roomDic["sendDate"] as! Timestamp
                        let sendDate       = stamp.dateValue()
                        let membersId      = roomDic["membersId"] as! [String]
                        let userOneName    = roomDic["userOneName"] as! String
                        let userOneAvatar  = roomDic["userOneAvatar"] as! String
                        let userTwoName    = roomDic["userTwoName"] as! String
                        let userTwoAvatar  = roomDic["userTwoAvatar"] as! String
                        let isUserOneSeen  = roomDic["isUserOneSeen"] as! Bool
                        let isUserTwoSeen  = roomDic["isUserTwoSeen"] as! Bool
                        
                        let privateRoom = PrivateRoom(roomIdentifier: roomIdentifier, membersId: membersId, lastMessage: lastMessage, isSeen: isSeen, sendDate: sendDate, userOneName: userOneName, userOneAvatar: userOneAvatar, userTwoName: userTwoName, userTwoAvatar: userTwoAvatar, isUserOneTyping: false, isUserTwoTyping: false, isUserOneSeen: isUserOneSeen, isUserTwoSeen: isUserTwoSeen)
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




