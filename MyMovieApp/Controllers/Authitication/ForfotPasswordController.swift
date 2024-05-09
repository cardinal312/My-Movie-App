//
//  ForfotPasswordController.swift
//  MyMovieApp
//
//  Created by Macbook on 29/4/24.
//

import UIKit

final class ForfotPasswordController: UIViewController {

    // MARK: - UI Components
    private let headerView = AuthHeaderView(title: .forgotTitle, subTitle: .forgotSubTitle)
    private let emailField = CustomTextField(fieldType: .email)
    private let resetPasswordButton = CustomButton(title: .signUpTitle, hasBackground: true, fontSize: .big)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.resetPasswordButton.addTarget(self, action: #selector(didTapForgotPasswordButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(resetPasswordButton)
        
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.emailField.translatesAutoresizingMaskIntoConstraints = false
        self.resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 280),
            
            self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            self.emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.resetPasswordButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
            self.resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
    }
    
    // MARK: - Selectors
    @objc private func didTapForgotPasswordButton() {
        let email = emailField.text ?? ""
        
        if !Validator.isValidEmail(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthManager.shared.forgotPassword(with: email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showSendingPasswordReset(on: self, with: error)
                return
            }
            	
            AlertManager.showPasswordResetSent(on: self)
        }
    }
}
