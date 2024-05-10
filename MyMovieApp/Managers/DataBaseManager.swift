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
    let id: String
    let username: String
    let email: String
    let avatar: String
}

final class DataBaseManager {
    
    // MARK: - Variables
    static let shared = DataBaseManager()
    private init() {}
    
    
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
                    let userId = snapshotData["userID"] as? String

                    let user = User(username: username ?? "", email: email ?? "", userUID: userUID, avatar: avatar ?? "")
                    
                    DispatchQueue.main.async {
                        compleation(user, nil)
                }
            }
        }
    }
    
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
                            let id = data["userID"] as? String
                            
                            let user = CurrentUser(id: id ?? "", username: username ?? "", email: email ?? "", avatar: avatar ?? "")
                            currentUsers.append(user)
                        }
                        compleation(currentUsers)
                    }
                    
                } else {
                    print("Failed fatching users")
                }
            }
        }
    
    //messages
    
    
    func sendMessage(otherId: String, convoId: String?, text: String, complition: @escaping (String) -> ()) {
        
        let ref = Firestore.firestore()
        
        if let uid = Auth.auth().currentUser?.uid {
            if convoId == nil {
                //create new chats dialog
                let convoId = UUID().uuidString
                
                
                let selfData: [String: Any] = [
                    "date": Date(),
                    "otherId": otherId
                ]
                
                let otherData: [String: Any] = [
                    "date": Date(),
                    "otherId": uid
                ]
                
                // we have chat with person X
                
                ref.collection("users")
                    .document(uid)
                    .collection("conversations")
                    .document(convoId)
                    .setData(selfData)
                
                // Person X have chat with me
                
                ref.collection("users")
                    .document(otherId)
                    .collection("conversations")
                    .document(convoId)
                    .setData(otherData)
                
                
                let msg: [String: Any] = [
                    "date": Date(),
                    "sender": uid,
                    "text": text ]
                
                let convoInfo: [String: Any] = [
                    "date": Date(),
                    "selfSender": uid,
                    "otherSender": otherId
                    
                ]
                
                ref.collection("conversations")
                    .document(convoId)
                    .setData(convoInfo) { error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        ref.collection("conversations")
                            .document(convoId)
                            .collection("messages")
                            .addDocument(data: msg) { error in
                                if error == nil {
                                    complition(convoId)
                                }
                                
                            }
                        }
            } else {
                // chat dialog haved
                
                let msg: [String: Any] = [
                    "date": Date(),
                    "sender": uid,
                    "text": text]
                
                Firestore.firestore().collection("conversations").document(convoId!).collection("messages").addDocument(data: msg) { error in
                    
                    if error == nil {
                        complition(convoId!)
                    }
                }
            }
        }
    }
    
    func getConvoId(otherId: String, completion: @escaping (String) -> ()) {
            if let uid = Auth.auth().currentUser?.uid {
                let ref = Firestore.firestore()
                
                ref.collection("users")
                    .document(uid)
                    .collection("conversations")
                    .whereField("otherId", isEqualTo: otherId)
                    .getDocuments { snap, error in
                        if error != nil {
                            return
                        }
                        if let snap = snap, !snap.documents.isEmpty {
                            let doc = snap.documents.first
                            if let convoId = doc?.documentID {
                                completion(convoId)
                            }
                        }
                    }
            }
        }
    
    func getAllMessages(chatId: String, complition: @escaping ([Message]) -> ()) {
            
            if let uid = Auth.auth().currentUser?.uid {
                
                let ref = Firestore.firestore()
                ref.collection("conversations")
                    .document(chatId)
                    .collection("messages")
                    .limit(to: 50)
                    .order(by: "date" , descending: false)
                    .addSnapshotListener { snap, error in
                        if error != nil {
                            print(error?.localizedDescription)
                            return
                        }
                        
                        if let snap = snap, !snap.documents.isEmpty {
                            
                            var msgs = [Message]()
                            //Message(sender: selfSender, messageId: "", sentDate: Date(), kind: .text(text))
                            
                            var sender = Sender(photoURL: "", senderId: uid, displayName: "Me")
                            
                            for doc in snap.documents {
                                let data = doc.data()
                                let userId = data["sender"] as! String
                                
                                let messageId = doc.documentID
                                
                                let date = data["date"] as! Timestamp
                                let sentDate = date.dateValue()
                                let text = data["text"] as! String
                                
                                if userId == uid {
                                    sender = Sender(photoURL: "", senderId: "1", displayName: "")
                                } else {
                                    sender = Sender(photoURL: "", senderId: "2", displayName: "")
                                }
                                msgs.append(Message(sender: sender, messageId: messageId, sentDate: sentDate, kind: .text(text)))
                            }
                            complition(msgs)
                        }
                                 }
                             }
                         }
    
    func getOneMessage() {
            
            
        }
    
}
