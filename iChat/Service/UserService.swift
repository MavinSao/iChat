//
//  UserService.swift
//  iChat
//
//  Created by Mavin Sao on 16/9/21.
//

import Foundation
import FirebaseFirestore

struct UserService {
    static let shared = UserService()
    
    private let db = Firestore.firestore()
    
    func fetchUserByUID(uid: String,completion: @escaping(Result<User,Error>)->Void){
        db.collection("Users").document(uid).getDocument { snapshot, error in
            if let error = error{
                completion(.failure(error))
            }
            
            guard let snapshot = snapshot else{
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
                completion(.success(user))
            }
            
        }
    }
    
    func fetchAllUsers (completion: @escaping(Result<[User],Error>)->Void){
        db.collection("Users").getDocuments { snapshots, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let snapshots = snapshots else {return}
            
            var users: [User] = []
            
            for snapshot in snapshots.documents {
                let userDic        = snapshot.data()
                let id             = userDic["id"] as! String
                let username       = userDic["username"] as! String
                let fullname       = userDic["fullname"] as! String
                let email          = userDic["email"] as! String
                let avatar         = userDic["avatar"] as! String
          
                let user = User(id: id, username: username, fullname: fullname, email: email, avatar: avatar)
                users.append(user)
            }
            completion(.success(users))
        }
    }
    
}
