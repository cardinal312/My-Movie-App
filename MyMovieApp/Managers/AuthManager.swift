//
//  AuthManager.swift
//  MyMovieApp
//
//  Created by Macbook on 2/5/24.
//

import FirebaseAuth
import FirebaseFirestore

final class AuthManager {
    
    static let shared = AuthManager()
    private init() {}
    
    // A method to register the user
    // - Parameters:
    //    - userRequest: The user informashion (username, email, password)
    //    - compleation: A compleation with two values:
    //    - Bool: User was registered (saved) or not in data base correctly
    //    - Error: An optional errors with connection to data base
    
    func registerUser(with userRequest: RegisterUserRequest, compleation: @escaping (Bool, NetworkError?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        let avatar = userRequest.avatar
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error)
                compleation(false, .registerUser)
                return
            }
            
            guard let resultUser = result?.user else {
                compleation(false, nil)
                return
            }
            
            let db = Firestore.firestore() // Referense to data base
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username" : username,
                    "email" : email,
                    "avatar" : avatar
                ]) { error in
                    if let error = error {
                        print(error)
                        compleation(false, .passUserDataToCollectionUser)
                        return
                    }
                    compleation(true, nil) // If successfuly pass user data to db
            }
        }
    }
    
    func signIn(with userRequest: LoginUserRequest, compleation: @escaping (NetworkError?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                print(error)
                compleation(.signInAuth)
                return
            } else {
                compleation(nil)
            }
        }
    }
    
    func signOut(completion: @escaping (NetworkError?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            print(error.localizedDescription)
            completion(.errorWithSignOut)
        }
    }
    
    func forgotPassword(with email: String, compleation: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            compleation(error)
        }
    }
    
    func fetchUser(compleation: @escaping (User?, NetworkError?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userUID)
            .getDocument { snapshot, error in
                
                if let error = error {
                    print(error)
                    compleation(nil, .fetchUser)
                    return
                }
                
                if let snapshot = snapshot, let snapshotData = snapshot.data() {
                    let username = snapshotData["username"] as? String
                    let email = snapshotData["email"] as? String
                    let avatar = snapshotData["avatar"] as? String

                    let user = User(username: username ?? "", email: email ?? "", avatar: avatar ?? "")
                    
                    DispatchQueue.main.async {
                        compleation(user, nil)
                }
            }
        }
    }
}
