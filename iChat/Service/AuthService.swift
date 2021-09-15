//
//  AuthService.swift
//  iChat
//
//  Created by Mavin Sao on 15/9/21.
//

import Foundation
import Firebase
import FirebaseFirestore

struct AuthService {
    
    static let shared = AuthService()
    
    private let db = Firestore.firestore()
    
    var localDb = UserDefaults.standard
    
    func register(username: String,fullname: String,email: String,password: String, avatar: String, completion: @escaping (Result<String,Error>)->Void){
 
        Auth.auth().createUser(withEmail: email, password: password) { authData, error in
            
            if let error = error {
                print("error",error.localizedDescription)
            }else{
                guard let result = authData else{
                    return
                }
                print("==result==",result.user.uid)
                
                let user = User(id: result.user.uid, username: username, fullname: fullname, email: email, avatar: avatar)
                
                db.collection("Users").document(user.id!).setData(user.dictionary) { error in
                    guard let error = error else{
                        completion(.success("Register to Database success"))
                        return
                    }
                    completion(.failure(error))
                }
                
            }
        }
    }
     
    
    func login(email: String, password: String, completion: @escaping (Result<String,Error>)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            
            if let error = error {
                completion(.failure(error))
            }
            guard let authData = authData else {return}
            
            db.collection("Users").document(authData.user.uid).getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let snapshot = snapshot else {
                    return
                }
                
                if snapshot.exists {
                    let userDic = snapshot.data()!
                    let id       = userDic["id"] as! String
                    let username = userDic["username"] as! String
                    let fullname = userDic["fullname"] as! String
                    let email    = userDic["email"] as! String
                    let avatar   = userDic["avatar"] as! String
                    
                    let user = User(id: id, username: username, fullname: fullname, email: email, avatar: avatar)
                 
                    do {
                        // Create JSON Encoder
                        let encoder = JSONEncoder()

                        // Encode Note
                        let data = try encoder.encode(user)

                        // Write/Set Data
                        UserDefaults.standard.set(data, forKey: "user")
                        
                        completion(.success("Login Successfully"))

                    } catch {
                        print("Unable to Encode Note (\(error))")
                    }
                    
                }else{
                    print("Please Register Your Account")
                    completion(.failure(AuthError.userNotFound))
                }
                
                
                
                
                
            }
           
        
        }
    }
    
    func logout() {
        
    }
    
    
}
