//
//  String + Extension.swift
//  MyMovieApp
//
//  Created by Macbook on 29/4/24.
//

import Foundation

extension String {
    static let signInTitle = "Sign in"
    static let signUpTitle = "Sign Up"
    
    static let loginSubTitle = "Sign in to your account"
    static let registerSubTitle = "Create your account"
    
    static let forgotTitle = "Forgot Password"
    static let forgotSubTitle = "Reset your password"
    
    static let loginLogo = "loginLogo"
    static let homeLeftBarButton = "loginLogo2"
    static let registerTerms = "By creating an account, you agree to our Terms & Conditions and you acknowledge that you have read our Privacy Policy."
    static let termsAndConditions = "Terms & Conditions"
    static let privacyPolicy = "Privacy Policy"
    
    static let webViewUrl = "https://kartinki.pics/uploads/posts/2022-02/1644998215_33-kartinkin-net-p-kartinki-geroi-marvel-37.jpg"
    static let googleTermsServiceUrl = "https://policies.google.com/terms?hl=en"
    static let googlePrivacyServiceUrl = "https://policies.google.com/privacy?hl=en"
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
