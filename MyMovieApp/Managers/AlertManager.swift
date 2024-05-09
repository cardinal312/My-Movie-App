//
//  AlertManager.swift
//  MyMovieApp
//
//  Created by Macbook on 30/4/24.
//

import UIKit

final class AlertManager {
    
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dissmis", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

// MARK: - Show Validation Alerts
extension AlertManager {
    
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Email", message: "Please enter a valid email.")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Password", message: "Please enter a valid password.")
    }
    
    public static func showInvalidUserNameAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Username", message: "Please enter a valid Username.")
    }
}

// MARK: - Show Registation Errors
extension AlertManager {
    
    public static func showRegistationErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknown Registration Error", message: nil)
    }
    
    public static func showRegistationErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Unknown Registration Error", message: "\(error.localizedDescription)")
    }
}

// MARK: - Log In Errors
extension AlertManager {
    
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknown Error Signing In", message: nil)
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error Signing In", message: "\(error.localizedDescription)")
    }
}

// MARK: - Logout Errors
extension AlertManager {
    
    public static func showLogoutErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Log Out Error", message: "\(error.localizedDescription)")
    }
}

// MARK: - Forgot Password
extension AlertManager {
    
    public static func showPasswordResetSent(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Password Reset Sent", message: nil)
    }
    
    public static func showSendingPasswordReset(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error Sending Password Reset", message: "\(error.localizedDescription)")
    }
}

// MARK: - Fetching User Errors
extension AlertManager {
    
    public static func showUserFetchingError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error Fetching User", message: "\(error.localizedDescription)")
    }
    
    public static func showUnknownFetchingUserError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknown Fetching User Error", message: nil)
    }
}


