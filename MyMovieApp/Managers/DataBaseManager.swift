//
//  DataBaseManager.swift
//  MyMovieApp
//
//  Created by Macbook on 9/5/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct CurrentUser {
    let username: String
    let email: String
    let avatar: String
}

final class DataBaseManager {
    
    // MARK: - Variables
    static let shared = DataBaseManager()
    private init() {}
    
    func fetchAllUsers(compleation: @escaping ([CurrentUser]) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }
        var currentUsers = [CurrentUser]()
        
        Firestore.firestore().collection("users")
            .whereField("email", isNotEqualTo: email)      // Its me in FB
            .getDocuments { snap, error in
                
                if error == nil {
                    if let docs = snap?.documents {
                        for doc in docs {
                            let data = doc.data()
                            let userId = doc.documentID
                            let email = data["email"] as? String
                            let avatar = data["avatar"] as? String
                            let username = data["username"] as? String
                            
                            let user = CurrentUser(username: username ?? "", email: email ?? "", avatar: avatar ?? "")
                            currentUsers.append(user)
                        }
                        compleation(currentUsers)
                    }
                    
                } else {
                    print("Failed fatching users")
                }
                
                
            }
        
        /**
         
         
         func getAllUsers(complition: @escaping ([CurrentUser]) -> ()) {
         
         guard let email = Auth.auth().currentUser?.email else { return }
         
         var currentUsers = [CurrentUser]()
         
         Firestore.firestore().collection("users")
         .whereField("email", isNotEqualTo: email)      // Its me in FB
         .getDocuments { snap, error in
         
         if error == nil {
         if let docs = snap?.documents {
         for doc in docs {
         let data = doc.data()
         let userId = doc.documentID
         let email = data["email"] as? String
         let avatar = data["avatar"] as? String
         
         currentUsers.append(CurrentUser(id: userId, email: email ?? "data == nil", avatar: avatar ?? "No wolf"))
         }
         }
         complition(currentUsers)
         }
         }
         }
         */
        // MARK: - Setup UI
        
        // MARK: - _ Methods
    }
}
