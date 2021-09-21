//
//  ViewController.swift
//  iChat
//
//  Created by Mavin Sao on 14/9/21.
//

import UIKit
import FirebaseFirestore
import ProgressHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let currentUser = ChatService.shared.currentUser
        let userID = UserDefaults.standard.string(forKey: "currentID")
        
        ProgressHUD.animationType = .horizontalCirclesPulse
        ProgressHUD.colorHUD = .darkGray
        ProgressHUD.colorBackground = .systemGray6
        ProgressHUD.show()
        
        if let safeCurrentUser = currentUser, let id = userID{
            
            if safeCurrentUser.id ?? "" == id{
                print("App")
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "appSegue", sender: self)
                }
            
            }else{
                print("Login")
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                     self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }else{
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                 self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
        
    }
}


   

