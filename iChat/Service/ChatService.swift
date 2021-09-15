//
//  ChatService.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import Foundation
import FirebaseFirestore

struct ChatService {
    static let shared = ChatService()
    
    private let db = Firestore.firestore()
    
    //Get Current User from local storage
    let currentUser = User(id: "vJdho07ltsOUBx95USUDsTWHxfh2", username: "mavin", fullname: "Mavin Sao", email: "mavinsao11@gmail.com", avatar: "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png")
    
    //Get Object User That We Choose To Chat with
    let targetUser = User(id: "M8FFRNMLgHXcz1MfUjnwgnQx1ts1", username: "tara", fullname: "Tara Kit", email: "tara@gmail.com", avatar: "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png")
     
    func sendMessage(message: String,roomIdentifier: String,reciver: User) {
        let messageObj = Message(roomIdentifier: roomIdentifier, senderId: currentUser.id!, senderName: currentUser.username!, senderAvatar: currentUser.avatar!, recieverId: reciver.id, recieverName: reciver.username!, recieverAvatar: reciver.avatar!, sendDate: Date(), messageText: message, mediaURL: "", status: false)
        
        db.collection("Messages").addDocument(data: messageObj.dictionary) { error in
            if let error = error {
                print(error.localizedDescription)
            }else{
                
                db.collection("PrivateRoom").document(roomIdentifier).setData(["lastMessage": message],merge: true)
                
                print("Send Message Success")
            }
        }
        
    }
    
    func fetchAllChatRoomByUID(uid:String){
        print("fetching...")
        db.collection("PrivateRoom").whereField("membersId", arrayContains: uid).getDocuments { snapshot, error in
            
            print("Fisnished")
            
            if let error = error {
                print("==>Error",error.localizedDescription)
            }
            guard let snapshot = snapshot else{
                print("snapshot nil")
                return
            }
            
            print("snapshot:", snapshot.documents.count)
            
            for document in snapshot.documents {
                print("data")
                print("\(document.documentID) => \(document.data())")
            }
            
        }
    }
    //CreateRoom
    func createRoom(userId: String)  {
        
        //Create Room Object
        let privateId = currentUser.id! + "_" + targetUser.id!
        let privateRoom = PrivateRoom(roomIdentifier: privateId, membersId: [currentUser.id!,targetUser.id!], lastMessage: "", isSeen: false)
        
        db.collection("PrivateRoom").document(privateId).getDocument { snapshot, error in
            guard let snapshot = snapshot else {
                print("nil snapshot")
                return
            }
            if(!snapshot.exists){
                db.collection("PrivateRoom").document(privateId).setData(privateRoom.dictionary, merge: false) { error in
                    if let error = error {
                       print(error.localizedDescription)
                    }else{
                       print("Create Room Successfully")
                    }
                }
            }
        }
 
        
    }
    
}
