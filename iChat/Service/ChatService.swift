//
//  ChatService.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import Foundation
import FirebaseFirestore
import ProgressHUD

struct ChatService {
    static let shared = ChatService()
    private let db = Firestore.firestore()
    
    var localDb = UserDefaults.standard
    
    var currentUser: User? {
        get{
            do {
                // Create JSON Encoder
                let decoder = JSONDecoder()
                if let userData = localDb.data(forKey: "user"){
                    let user = try decoder.decode(User.self, from: userData)
                    return user
                }else{
                    return nil
                }
            } catch {
                return nil
                print("Unable to Encode Note (\(error))")
            }
        }
    }
    
    func fetchMessagesByRoomId(roomIdentifier: String,completion: @escaping (Result<[Message],Error>)->Void){
        

   }
        

    
    func sendMessage(message: String,mediaURL: String?,roomIdentifier: String,reciverId: String, isUserOne: Bool, completion: @escaping (Result<String,Error>)->Void) {
        
        guard let currentUser = currentUser else {
            return
        }
        
        if isUserOne {
            db.collection("PrivateRoom").document(roomIdentifier).setData(["isUserTwoSeen": false], merge: true)
        }else{
            db.collection("PrivateRoom").document(roomIdentifier).setData(["isUserOneSeen": false], merge: true)
        }
        
        UserService.shared.fetchUserByUID(uid: reciverId) { result in
            switch result {
            case .success(let reciver):
                
                let messageObj = Message(roomIdentifier: roomIdentifier, senderId: currentUser.id!, senderName: currentUser.username!, senderAvatar: currentUser.avatar!, recieverId: reciver.id, recieverName: reciver.username!, recieverAvatar: reciver.avatar!, sendDate: Date(), messageText: message , mediaURL: mediaURL ?? "", status: false, isDefault: false)
                    
                    db.collection("Messages").addDocument(data: messageObj.dictionary) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }else{
                            
                            let messageT = message == "" ? "Photo" : message
                            
                            db.collection("PrivateRoom").document(roomIdentifier).setData(["lastMessage": messageT,"sendDate": Date()],merge: true)
                            completion(.success("Send Message Success"))
                        }
                    }
            case .failure(let error): completion(.failure(error))
            
            }
        }
    }
    
    func deleteAllMessageByRoom(roomId: String)  {
             db.collection("Messages").whereField("roomIdentifier", isEqualTo: roomId).getDocuments { snapshots, error in
        
                        if let error = error {
                            ProgressHUD.showError(error.localizedDescription)
                        }
        
                        guard let safeSnapshots = snapshots else {return}
        
                        for snapshot in safeSnapshots.documents {
                            snapshot.reference.delete()
                        }
        
               }
    }
    
    func deleteChatRoom(roomId: String) {
        db.collection("PrivateRoom").document(roomId).delete { error in
            if let error = error{
                ProgressHUD.showError(error.localizedDescription)
            }
            self.deleteAllMessageByRoom(roomId: roomId)
        }
    }
    
    func fetchAllChatRoom(completion: @escaping (Result<[PrivateRoom],Error>)->Void){
        
        guard let currentUser = currentUser else {
            print("no user")
            return
        }
        print("Current User", currentUser)
        
        db.collection("PrivateRoom").whereField("membersId", arrayContains: currentUser.id!).getDocuments { snapshot, error in
            if let error = error {
                print("==>Error",error.localizedDescription)
                completion(.failure(error))
            }
            guard let snapshot = snapshot else{
                print("snapshot nil")
                return
            }
            
            var roomData: [PrivateRoom] = []
            
            for document in snapshot.documents {
                
                let roomDic        = document.data()
                let roomIdentifier = roomDic["roomIdentifier"] as! String
                let lastMessage    = roomDic["lastMessage"] as! String
                let isSeen         = roomDic["isSeen"] as! Bool
                let stamp             = roomDic["sendDate"] as! Timestamp
                let sendDate          = stamp.dateValue()
                let membersId      = roomDic["membersId"] as! [String]
                let userOneName    = roomDic["userOneName"] as! String
                let userOneAvatar    = roomDic["userOneAvatar"] as! String
                let userTwoName    = roomDic["userTwoName"] as! String
                let userTwoAvatar    = roomDic["userTwoAvatar"] as! String
                let isUserOneSeen  = roomDic["isUserOneSeen"] as! Bool
                let isUserTwoSeen  = roomDic["isUserTwoSeen"] as! Bool
                
                let privateRoom = PrivateRoom(roomIdentifier: roomIdentifier, membersId: membersId, lastMessage: lastMessage, isSeen: isSeen, sendDate: sendDate, userOneName: userOneName, userOneAvatar: userOneAvatar, userTwoName: userTwoName, userTwoAvatar: userTwoAvatar, isUserOneTyping: false, isUserTwoTyping: false, isUserOneSeen: isUserOneSeen, isUserTwoSeen: isUserTwoSeen)
       
                roomData.append(privateRoom)
                
            }  
            completion(.success(roomData))
        }
    }
    //CreateRoom
    func createRoom(withUser: User,compeltion: @escaping (Result<PrivateRoom,Error>)->Void)  {
        
        guard let currentUser = currentUser else {
            return
        }
        
        
        //Check if room exists from targetUser
        
        let checkId =  withUser.id! + "_" + currentUser.id!
    
        db.collection("PrivateRoom").document(checkId).getDocument { snapshot, error in
            guard let snapshot = snapshot else {
                print("nil snapshot")
                return
            }
            if(!snapshot.exists){
 
                //Check exist room with this id
                let privateId = currentUser.id! + "_" + withUser.id!
                
                db.collection("PrivateRoom").document(privateId).getDocument { snapshot, error in
                    guard let snapshot = snapshot else {
                        print("nil snapshot")
                        return
                    }
                    if(!snapshot.exists){
                        let privateRoom = PrivateRoom(roomIdentifier: privateId, membersId: [currentUser.id!,withUser.id!], lastMessage: "", isSeen: false, sendDate: Date(), userOneName: currentUser.fullname, userOneAvatar: currentUser.avatar , userTwoName: withUser.fullname, userTwoAvatar: withUser.avatar, isUserOneTyping: false, isUserTwoTyping: false, isUserOneSeen: false, isUserTwoSeen: false)
                             db.collection("PrivateRoom").document(privateId).setData(privateRoom.dictionary, merge: false) { error in
                                            if let error = error {
                                                compeltion(.failure(error))
                                            }else{
                                                print("open this new room")
                                                compeltion(.success(privateRoom))
                                            }
                            }
                    }else{
                        let privateRoomDic        = snapshot.data()
                        if let roomDic = privateRoomDic{
                            let roomIdentifier = roomDic["roomIdentifier"] as! String
                            let lastMessage    = roomDic["lastMessage"] as! String
                            let isSeen         = roomDic["isSeen"] as! Bool
                            let stamp             = roomDic["sendDate"] as! Timestamp
                            let sendDate          = stamp.dateValue()
                            let membersId      = roomDic["membersId"] as! [String]
                            let userOneName    = roomDic["userOneName"] as! String
                            let userOneAvatar    = roomDic["userOneAvatar"] as! String
                            let userTwoName    = roomDic["userTwoName"] as! String
                            let userTwoAvatar    = roomDic["userTwoAvatar"] as! String
                            let isUserOneSeen  = roomDic["isUserOneSeen"] as! Bool
                            let isUserTwoSeen  = roomDic["isUserTwoSeen"] as! Bool
                            
                            let existRoom = PrivateRoom(roomIdentifier: roomIdentifier, membersId: membersId, lastMessage: lastMessage, isSeen: isSeen, sendDate: sendDate, userOneName: userOneName, userOneAvatar: userOneAvatar, userTwoName: userTwoName, userTwoAvatar: userTwoAvatar,isUserOneTyping: false, isUserTwoTyping: false, isUserOneSeen: isUserOneSeen, isUserTwoSeen: isUserTwoSeen)
                            compeltion(.success(existRoom))
                            
                        }
                    }
                }
            }else{
                let roomDic        = snapshot.data()
                if let roomDic = roomDic{
                    let roomIdentifier = roomDic["roomIdentifier"] as! String
                    let lastMessage    = roomDic["lastMessage"] as! String
                    let isSeen         = roomDic["isSeen"] as! Bool
                    let stamp             = roomDic["sendDate"] as! Timestamp
                    let sendDate          = stamp.dateValue()
                    let membersId      = roomDic["membersId"] as! [String]
                    let userOneName    = roomDic["userOneName"] as! String
                    let userOneAvatar    = roomDic["userOneAvatar"] as! String
                    let userTwoName    = roomDic["userTwoName"] as! String
                    let userTwoAvatar    = roomDic["userTwoAvatar"] as! String
                    let isUserOneSeen  = roomDic["isUserOneSeen"] as! Bool
                    let isUserTwoSeen  = roomDic["isUserTwoSeen"] as! Bool
                    
                    let existRoom = PrivateRoom(roomIdentifier: roomIdentifier, membersId: membersId, lastMessage: lastMessage, isSeen: isSeen, sendDate: sendDate, userOneName: userOneName, userOneAvatar: userOneAvatar, userTwoName: userTwoName, userTwoAvatar: userTwoAvatar, isUserOneTyping: false, isUserTwoTyping: false, isUserOneSeen: isUserOneSeen, isUserTwoSeen: isUserTwoSeen)
                    compeltion(.success(existRoom))
                }
               
            }
        }
 
        
    }
    
}
