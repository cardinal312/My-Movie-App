//
//  Errors.swift
//  MyMovieApp
//
//  Created by Macbook on 30/4/24.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case registerUser
    case passUserDataToCollectionUser
    case signInAuth
    case errorWithSignOut
    case forgorPasswordService
    case fetchUser
}
