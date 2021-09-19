//
//  FileService.swift
//  iChat
//
//  Created by Mavin on 9/19/21.
//

import Foundation
import UIKit
import FirebaseStorage

struct FileService {
    static let shared = FileService()
    
    // Get a reference to the storage service using the default Firebase App
    let storage = Storage.storage()
    // Create a storage reference from our storage service
    
    
    let currentId = UserDefaults.standard.string(forKey: "currentID")
    
    func uploadImage(image: UIImage, completion: @escaping (Result<String,Error>)->Void) {
        
        guard let imageData: Data = image.jpegData(compressionQuality: 0.1) else {
                return
        }
        let storageRef = storage.reference()
        let uuid = UUID().uuidString
        
        storageRef.child("images/\(uuid)").putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.child("images/\(uuid)").downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let url = url else {
                    return
                }
                completion(.success(url.absoluteString))
            }
        
        }
        
    }
}
