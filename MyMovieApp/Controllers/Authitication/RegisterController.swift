//
//  RegisterController.swift
//  MyMovieApp
//
//  Created by Macbook on 29/4/24.
//

import UIKit

final class RegisterController: UIViewController {
    
    // MARK: - UI Components
    private let headerView = AuthHeaderView(title: .signUpTitle, subTitle: .registerSubTitle)
    private let userNameField = CustomTextField(fieldType: .userName)
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signUpButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .big)
    private let signInButton = CustomButton(title: "Already have an account? Sign In.", fontSize: .med)
    
    private let termsTextView: UITextView = {
        let atributedString = NSMutableAttributedString(string: .registerTerms)
        atributedString.addAttribute(.link, value: "terms://termsAndConditions", range: (atributedString.string as NSString).range(of: .termsAndConditions))
        atributedString.addAttribute(.link, value: "privacy://privacyPolicy", range: (atributedString.string as NSString).range(of: .privacyPolicy))
        
        let tv = UITextView()
        tv.linkTextAttributes = [.foregroundColor : UIColor.systemBlue]
        tv.backgroundColor = .clear
        tv.attributedText = atributedString
        tv.textColor = .label
        tv.isSelectable = true // if needed we can make false
        tv.isEditable = false
        tv.delaysContentTouches = false
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.termsTextView.delegate = self
        
        self.signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(headerView)
        self.view.addSubview(userNameField)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signUpButton)
        self.view.addSubview(termsTextView)
        self.view.addSubview(signInButton)
        
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.userNameField.translatesAutoresizingMaskIntoConstraints = false
        self.emailField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordField.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.userNameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.userNameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.userNameField.heightAnchor.constraint(equalToConstant: 55),
            self.userNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.emailField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 22),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: userNameField.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            self.signUpButton.centerXAnchor.constraint(equalTo: userNameField.centerXAnchor),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 55),
            self.signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.termsTextView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 6),
            self.termsTextView.centerXAnchor.constraint(equalTo: userNameField.centerXAnchor),
            self.termsTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 11),
            self.signInButton.centerXAnchor.constraint(equalTo: userNameField.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 44),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
    }
    
    // MARK: - Selectors
    @objc private func didTapSignUpButton() {
        let registerUserRequest = RegisterUserRequest(username: self.userNameField.text ?? "",
                                                      email: self.emailField.text ?? "",
                                                      password: self.passwordField.text ?? "")
        
        // Username check
        if !Validator.isValidUsername(for: registerUserRequest.username) {
            AlertManager.showInvalidUserNameAlert(on: self)
        }
        
        // Email check
        if !Validator.isValidEmail(for: registerUserRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
        }
        
        // Password check !Validator.isPasswordValid ????
        if Validator.isPasswordValid(for: registerUserRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
        }
        
        AuthManager.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showRegistationErrorAlert(on: self, with: error)
                return
            }
            
            if wasRegistered {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            } else {
                AlertManager.showRegistationErrorAlert(on: self)
            }
        }
    }
    
    @objc private func didTapSignInButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Extensions
extension RegisterController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "terms" {
            self.showViewerController(with: .googleTermsServiceUrl)
        } else if URL.scheme == "privacy" {
            self.showViewerController(with: .googlePrivacyServiceUrl)
        }
        return true
    }
    
    private func showViewerController(with urlString: String) {
        let vc = WebViewController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}
