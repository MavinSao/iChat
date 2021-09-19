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
    @IBOutlet weak var userProfileImage: UIImageView!
    var isImageUpdate: Bool?
    
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var pickImageCallback : ((UIImage) -> ())?;
    
    var imageURL: String?
    
    let imagePickerView = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAlert))
        self.userProfileImage.isUserInteractionEnabled = true
        self.userProfileImage.addGestureRecognizer(tapGesture)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
                    UIAlertAction in
                    self.chooseImage(type: .camera)
         }
                let galleryAction = UIAlertAction(title: "Gallery", style: .default){
                    UIAlertAction in
                    self.chooseImage(type: .photoLibrary)
          }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                    UIAlertAction in
                   
                }
        // Add the actions
        imagePickerView.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
    }

    @objc func presentAlert(){
        present(alert, animated: true, completion: nil)
    }
  
    
    func chooseImage(type: UIImagePickerController.SourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = type
        present(pickerController, animated: true, completion: nil)
        
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
            
            if isImageUpdate ?? false {
                FileService.shared.uploadImage(image: self.userProfileImage.image!, completion: {
                result in
                    switch result {
                    case .success(let url):
                        AuthService.shared.register(username: username, fullname: fullname, email: email, password: password, avatar: url, completion: {result in
                            
                            switch result {
                                case .success(let message):
                                    ProgressHUD.showSuccess(message)
                                case .failure(let error):
                                    ProgressHUD.showError(error.localizedDescription)
                            }
                        })
                        
                    case .failure(let error):
                        ProgressHUD.show(error.localizedDescription)
                    }
                })
            }else{
                FileService.shared.uploadImage(image: self.userProfileImage.image!, completion: {
                result in
                    switch result {
                    case .success(let url):
                        AuthService.shared.register(username: username, fullname: fullname, email: email, password: password, avatar: "", completion: {result in
                            
                            switch result {
                                case .success(let message):
                                    ProgressHUD.showSuccess(message)
                                case .failure(let error):
                                    ProgressHUD.showError(error.localizedDescription)
                            }
                        })
                        
                    case .failure(let error):
                        ProgressHUD.show(error.localizedDescription)
                    }
                })
            }
        }else{
            ProgressHUD.showError("Please check your password and confirm password...")
        }
        self.isImageUpdate = false
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
        if let possibleImage = info[.editedImage] as? UIImage {
                self.isImageUpdate = true
                self.userProfileImage.image = possibleImage
            } else {
                self.isImageUpdate = false
                return
            }
            // do something interesting here!
        print(self.userProfileImage.image!.size)

            dismiss(animated: true)
        
    }
}
