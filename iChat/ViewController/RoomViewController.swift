//
//  RoomViewController.swift
//  iChat
//
//  Created by Mavin Sao on 16/9/21.
//

import UIKit
import ProgressHUD
import FirebaseFirestore
import IQKeyboardManager
import Kingfisher

class RoomViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!

    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    

    var messages: [Message] = []
    var room: PrivateRoom?
    var recieverId: String?
    let currentId = UserDefaults.standard.string(forKey: "currentID")
    var isUserOne: Bool {
        return currentId == room?.membersId![0]
    }
    
    
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = .darkGray
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "RecieverTableViewCell", bundle: nil), forCellReuseIdentifier: "recieverCell")
        self.tableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "senderCell")
        IQKeyboardManager.shared().isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        overrideUserInterfaceStyle = .light
        
        prepareNav()
        fetchMessages()
        listenUserTypping()
     
    }
    
    func unsubscribeFromAllNotifications() {
            NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
    
        if notification.userInfo != nil {
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                       let keyboardRectangle = keyboardFrame.cgRectValue
                       let keyboardHeight = keyboardRectangle.height
                    
                    if notification.name == UIResponder.keyboardWillShowNotification{
                        self.bottomViewHeight.constant = keyboardHeight + 80
                        self.view.layoutIfNeeded()
                    }else{
                        self.bottomViewHeight.constant = self.bottomViewHeight.constant - keyboardHeight
                        self.view.layoutIfNeeded()
                    }
                   }
            }
        if self.messages.count != 0 {
            self.tableView.scrollToBottom()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        unsubscribeFromAllNotifications()
        IQKeyboardManager.shared().isEnabled = true
    }
    
    func prepareNav(){
        if isUserOne {
            self.title = room?.userTwoName
        }else{
            self.title = room?.userOneName
        }
    }
    
    //MARK: -Set user typing
    func setUserTyping(isTyping: Bool){
        
            if isTyping {
                if let safeRoom = room {
                    var messageTyping = Message(roomIdentifier: "", senderId: "", senderName: "", senderAvatar: "", recieverId: "", recieverName: "", recieverAvatar: "", sendDate: Date(), messageText: "Typing...", mediaURL: "", status: true, isDefault: true)
                   
                    if isUserOne {
                        messageTyping.senderAvatar = safeRoom.userTwoAvatar
                    }else{
                        messageTyping.senderAvatar = safeRoom.userOneAvatar
                    }
                      
                    if self.messages.count != 0 {
                        if !(self.messages[self.messages.count - 1].isDefault ?? false) {
                            self.messages.append(messageTyping)
                            self.tableView.performBatchUpdates ({
                                self.tableView.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .automatic)
                            }, completion: nil)
                       }
                    }

                }
            }else{
                if messages.count != 0{
                    if self.messages[self.messages.count - 1].isDefault ?? false {
                        self.messages.popLast()
                        self.tableView.reloadData()
                    }
                }
            }
        
    }
    

    @IBAction func btnSendPressed(_ sender: Any) {
        let message = messageTextField.text!
        if message != "" {
            ChatService.shared.sendMessage(message: message, roomIdentifier: room!.roomIdentifier!, reciverId: recieverId!, isUserOne: isUserOne)
            messageTextField.text = ""
        }
    }
    
    @IBAction func textMessageBeginEditing(_ sender: Any) {
        guard let safeRoom = room else {
            return
        }
        
        if isUserOne {
            db.collection("PrivateRoom").document(safeRoom.roomIdentifier!).setData(["isUserOneTyping": true],merge: true)
        }else{
            db.collection("PrivateRoom").document(safeRoom.roomIdentifier!).setData(["isUserTwoTyping": true],merge: true)
        }
        
       
    }
    
    @IBAction func textMessageEndEditing(_ sender: Any) {
        guard let safeRoom = room else {
            return
        }
        if isUserOne {
            db.collection("PrivateRoom").document(safeRoom.roomIdentifier!).setData(["isUserOneTyping": false],merge: true)
        }else{
            db.collection("PrivateRoom").document(safeRoom.roomIdentifier!).setData(["isUserTwoTyping": false],merge: true)
        }
    }
    
    
    
}

extension RoomViewController: UserProtocolDelegate{
    func didSent(recievedUser: User) {}
    
    func joinChat(room: PrivateRoom, recieverId: String) {
        print("reciever",room)
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


//MARK: - Handle keyboard

extension RoomViewController{
    
}


//MARK: - Listen Function and fetch firestore
extension RoomViewController {
    
    //MARK: -Listen User Typing
    func listenUserTypping(){
        guard let safeRoom = room else {
            return
        }
        db.collection("PrivateRoom").document(safeRoom.roomIdentifier!).addSnapshotListener {[weak self] snapshot, error in
            
            guard let safeSnapshot = snapshot else {return}
            
            if safeSnapshot.exists {
                if let self = self {
                    if safeSnapshot["isUserOneTyping"] as! Bool && safeSnapshot["isUserTwoTyping"] as! Bool{
                        self.setUserTyping(isTyping: true)
                    }else{
                        if self.isUserOne {
                            if safeSnapshot["isUserTwoTyping"] as! Bool {
                                self.setUserTyping(isTyping: true)
                            }else{
                                self.setUserTyping(isTyping: false)
                            }
                        }else{
                            if safeSnapshot["isUserOneTyping"] as! Bool {
                                self.setUserTyping(isTyping: true)
                            }else{
                                self.setUserTyping(isTyping: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: -Fetch All Message
    func fetchMessages(){
        
        if isUserOne{
            db.collection("PrivateRoom").document(room!.roomIdentifier!).setData(["isUserOneSeen":true], merge: true)
        }else{
            db.collection("PrivateRoom").document(room!.roomIdentifier!).setData(["isUserTwoSeen":true], merge: true)
        }
     
        
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
                if self.messages.count != 0 {
                    if self.isViewLoaded {
                        self.tableView.scrollToBottom()
                    }        
                }
            }
            
        })
    }
}
