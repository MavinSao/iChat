//
//  ChatViewController.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import UIKit
import ProgressHUD

class ChatViewController: UIViewController {

    var roomData: [PrivateRoom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchAllChats()
    }
    
    func fetchAllChats(){
        ChatService.shared.fetchAllChatRoom { result in
            switch result {
            case .success(let rooms):
                print("rooms",rooms)
                   self.roomData=rooms
            case .failure(let err):
                   ProgressHUD.showError(err.localizedDescription)
            }
        }
    }
}
