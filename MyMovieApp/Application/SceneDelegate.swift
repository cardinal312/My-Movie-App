//
//  SceneDelegate.swift
//  MyMovieApp
//
//  Created by Macbook on 29/4/24.
//

import UIKit
import FirebaseAuth

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        self.checkAuthentication()
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
    }
    
    public func checkAuthentication() {
        //UserDefaults.standard.set(true, forKey: "signOut")
        if Auth.auth().currentUser == nil, UserDefaults.standard.bool(forKey: "signOut") { // UserDefaults settings from HomeController
            // Go to sign screen
            self.goToController(with: LoginController())
        } else {
            // Go to tabBar controller
            self.goToController(with: MainTabBarControllerViewController())
        }
    }
    
    private func goToController(with viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
                
            } completion: { [weak self] _ in
                let nav = UINavigationController(rootViewController: viewController)
                nav.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = nav
                
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
    
    // MARK: - Scenes lifecycle
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

