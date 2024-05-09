//
//  StorageManager.swift
//  MyMovieApp
//
//  Created by Macbook on 9/5/24.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

final class StorageManager {
    
    enum StorageErrors: Error {
        case failedToUpload, failedToGetDownloadUrlString
    }
    
    //MARK: - Variables
    static let shared = StorageManager()
    private init() {}
    
    private let storage = Storage.storage().reference()
    public typealias UploadPProfileictureCompleation = (Result<String, StorageErrors>) -> Void
    
    //MARK: - Uploads profile picture to firebase storage and return compleation with url string do download for SDWebImage
    public func uploadProfilePicture(with data: Data, fileName: String, compleation: @escaping UploadPProfileictureCompleation) {
        self.storage.child("images/\(fileName)").putData(data) { metadata, error in
            guard error == nil else {
                //failed
                print("Failed to upload data to firebase to for picture ")
                compleation(.failure(.failedToUpload))
                return
            }
            
            //download url by picture from firebase storage
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("Failed to get download profile picture url")
                    compleation(.failure(.failedToGetDownloadUrlString))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url returned: --->>>\(urlString)<<<---")
                
                compleation(.success(urlString))
                
                //MARK: - Put uploaded imageString to FireStore user avatar value
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                
                let db = Firestore.firestore() // Referense to data base
                db.collection("users").document(userUID).updateData(["avatar" : urlString])
                print("Successfuly uploaded photo")
                }
            }
        }
    }

