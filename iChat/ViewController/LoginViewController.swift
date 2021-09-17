//
//  LoginViewController.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.windows.first
        let mainTab = storyboard?.instantiateViewController(identifier: "MainTabBar")
        
        ProgressHUD.animationType = .horizontalCirclesPulse
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.show()
    
        AuthService.shared.login(email: emailTextField.text!, password: passwordTextField.text!, completion: {
                result in
                switch result {
                    case .success(let message):
                          print(message)
                          ProgressHUD.dismiss()
                          appDelegate?.rootViewController = mainTab
                case .failure(let error):  ProgressHUD.showError(error.localizedDescription)
                }
                
            })
        }
       
    

}
