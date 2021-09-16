//
//  RoomViewController.swift
//  iChat
//
//  Created by Mavin Sao on 16/9/21.
//

import UIKit
import ProgressHUD
import FirebaseFirestore

class RoomViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    
    var messages: [Message] = []
    var room: PrivateRoom?
    var recieverId: String?
    let currentId = UserDefaults.standard.string(forKey: "currentID")
    
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = .darkGray
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "RecieverTableViewCell", bundle: nil), forCellReuseIdentifier: "recieverCell")
        self.tableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "senderCell")
        
        prepareNav()
        fetchMessages()
     
    }
    
    func prepareNav(){
        let barButton = UIBarButtonItem(image: UIImage(named: "personal.fill"), style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = barButton
        
        
        
        if currentId == room?.membersId![0] {
            self.title = room?.userTwoName
        }else{
            self.title = room?.userOneName
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func btnSendPressed(_ sender: Any) {
        let message = messageTextField.text!
        ChatService.shared.sendMessage(message: message, roomIdentifier: room!.roomIdentifier!, reciverId: recieverId!)
    }
    
}

extension RoomViewController: UserProtocolDelegate{
    func didSent(recievedUser: User) {}
    
    func joinChat(room: PrivateRoom, recieverId: String) {
        self.room = room
        self.recieverId = recieverId
    }
    
}

extension RoomViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let senderCell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! SenderTableViewCell
        let recieverCell = tableView.dequeueReusableCell(withIdentifier: "recieverCell", for: indexPath) as! RecieverTableViewCell
        
        if messages[indexPath.row].senderId == currentId{
            senderCell.config(message: messages[indexPath.row])
            senderCell.selectionStyle = .none
            return senderCell
        }else{
            recieverCell.config(message: messages[indexPath.row])
            recieverCell.selectionStyle = .none
            return recieverCell
        }
    }
}

extension RoomViewController {
    func fetchMessages(){
        db.collection("Messages").whereField("roomIdentifier", isEqualTo: room!.roomIdentifier!).order(by: "sendDate",descending: false).addSnapshotListener({ snapshot, error in
            if let error = error {
                print("err",error.localizedDescription)
                ProgressHUD.showError(error.localizedDescription)
            }
            guard let snapshot = snapshot else{
                print("snapshot nil")
                return
            }
            var messagesData: [Message] = []

            for document in snapshot.documents {

                let messageDic        = document.data()
                let roomIdentifier    = messageDic["roomIdentifier"] as! String
                let senderId          = messageDic["senderId"] as! String
                let senderName        = messageDic["senderName"] as! String
                let senderAvatar      = messageDic["senderAvatar"] as! String
                let recieverId        = messageDic["recieverId"] as! String
                let recieverName      = messageDic["recieverName"] as! String
                let recieverAvatar    = messageDic["recieverAvatar"] as! String
                let stamp             = messageDic["sendDate"] as! Timestamp
                let sendDate          = stamp.dateValue()
                let messageText       = messageDic["messageText"] as! String
                let mediaURL          = messageDic["mediaURL"] as! String
                let status            = messageDic["status"] as! Bool

               let message = Message(roomIdentifier: roomIdentifier, senderId: senderId, senderName: senderName, senderAvatar: senderAvatar, recieverId: recieverId, recieverName: recieverName, recieverAvatar: recieverAvatar, sendDate: sendDate, messageText: messageText, mediaURL: mediaURL, status: status)
                messagesData.append(message)
            }
            
            DispatchQueue.main.async {
                self.messages = messagesData
                self.tableView.reloadData()
            }
            
        })
    }
}
