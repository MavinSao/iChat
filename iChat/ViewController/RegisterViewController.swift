//
//  RegisterViewController.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import UIKit

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
            
            AuthService.shared.register(username: username, fullname: fullname, email: email, password: password, avatar: "", completion: {result in
                
                switch result {
                    case .success(let message):
                          print(message)
                    case .failure(let error):
                          print(error.localizedDescription)
                }
                
            })
            
        }else{
            print("Please check your password and confirm password...")
        }
        
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
