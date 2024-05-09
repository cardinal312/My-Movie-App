//
//  CustomTextField.swift
//  MyMovieApp
//
//  Created by Macbook on 29/4/24.
//

import UIKit

final class CustomTextField: UITextField {

    enum CustomTextFieldType {
        case userName
        case email
        case password
    }
    
    private let authFieldType: CustomTextFieldType
    
    init(fieldType: CustomTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        switch fieldType {
        case .userName:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email Adress"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Password"
            self.isSecureTextEntry = true
            self.textContentType = .oneTimeCode
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
