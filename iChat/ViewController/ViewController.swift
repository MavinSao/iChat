//
//  ViewController.swift
//  iChat
//
//  Created by Mavin Sao on 14/9/21.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ChatService.shared.fetchAllChatRoomByUID(uid: "vJdho07ltsOUBx95USUDsTWHxfh2")
    }
    


    @IBAction func SignInPressed(_ sender: Any) {
        register()
    }
    
    @IBAction func chatPressed(_ sender: Any) {
        createRoom()
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        sendMessage()
    }
    
    //Get Current User from local storage
    let user1 = User(id: "vJdho07ltsOUBx95USUDsTWHxfh2", username: "mavin", fullname: "Mavin Sao", email: "mavinsao11@gmail.com", avatar: "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png")
    
    //Get Object User That We Choose To Chat with
    let user2 = User(id: "M8FFRNMLgHXcz1MfUjnwgnQx1ts1", username: "tara", fullname: "Tara Kit", email: "tara@gmail.com", avatar: "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png")
    
    func sendMessage() {
        let messageTest = "YESYES"
        let roomIden = "vJdho07ltsOUBx95USUDsTWHxfh2_M8FFRNMLgHXcz1MfUjnwgnQx1ts1"
    
        
        ChatService.shared.sendMessage(message: messageTest, roomIdentifier: roomIden, reciver: user1)
        
    }
    
    func register(){
        let email =  "mavinsao11@gmail.com"
        let password = "12345678"
        let username = "mavin"
        let fullname = "Mavin Sao"
        let avartar  = "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png"
       //User 2
//        let email =  "tara@gmail.com"
//        let password = "12345678"
//        let username = "tara"
//        let fullname = "tara kit"
//        let avartar  = "https://cliply.co/wp-content/uploads/2020/08/442008112_GLANCING_AVATAR_3D_400.png"
        
//        AuthService.shared.register(username: username, fullname: fullname, email: email, password: password, avatar: avartar)
//        
    }
    
    func createRoom(){
        let withUser = "oJ4oyy4E1HOioAu7c62IZMiH41P2"
        ChatService.shared.createRoom(userId: withUser)
    }

}

