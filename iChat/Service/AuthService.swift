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
    
    var defaults = UserDefaults.standard
    
    func register(username: String,fullname: String,email: String,password: String, avatar: String, completion: @escaping (Result<String,Error>)->Void){
 
        Auth.auth().createUser(withEmail: email, password: password) { authData, error in
            if let error = error {
                print("error",error.localizedDescription)
            }else{
                guard let result = authData else{
                    return
                }
                
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
                        defaults.set(data, forKey: "user")
                        defaults.set(id, forKey: "currentID")
                        
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
    
    func checkExistUser(completion: @escaping(Bool)->Void){
        do {
            // Create JSON Encoder
            let decoder = JSONDecoder()
            if let userData = defaults.data(forKey: "user"){
                let user = try decoder.decode(User.self, from: userData)
                
                db.collection("Users").document(user.id!).getDocument { snapshot, err in
                    if err != nil {return}
                    if let snapshot = snapshot {
                        completion(snapshot.exists)
                    }
                }
                
            }else{
                completion(false)
            }
        } catch {
            completion(false)
            print("Unable to Encode Note (\(error))")
        }
    }
    
    func logout(completion: @escaping(Result<Bool,Error>)->Void) {
        do{
            try Auth.auth().signOut()
            defaults.set(nil, forKey: "currentID")
            defaults.set(nil, forKey: "user")
            completion(.success(true))
        }catch(let error){
            completion(.failure(error))
        }
    }
}
