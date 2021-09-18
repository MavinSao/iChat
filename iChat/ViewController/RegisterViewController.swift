//
//  RegisterViewController.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import UIKit
import ProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField   : UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField  : UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        let username = usernameTextField.text!
        let fullname = fullnameTextField.text!
        let email    = emailTextField.text!
        let password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        
        if password == confirmPassword {
            
            ProgressHUD.animationType = .horizontalCirclesPulse
            ProgressHUD.colorHUD = .darkGray
            ProgressHUD.colorBackground = .systemGray6
            ProgressHUD.show()
            AuthService.shared.register(username: username, fullname: fullname, email: email, password: password, avatar: "", completion: {result in
                
                switch result {
                    case .success(let message):
                        ProgressHUD.showSuccess(message)
                    case .failure(let error):
                        ProgressHUD.showError(error.localizedDescription)
                }
                
            })
            
        }else{
            ProgressHUD.showError("Please check your password and confirm password...")
        }
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
