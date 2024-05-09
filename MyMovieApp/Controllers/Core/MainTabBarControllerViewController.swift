//
//  MainTabBarControllerViewController.swift
//  MyMovieApp
//
//  Created by Macbook on 2/5/24.
//

import UIKit

final class MainTabBarControllerViewController: UITabBarController {
    
    // MARK: - UI Components
    public lazy var customBar: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.backgroundColor = .white.withAlphaComponent(0.9)
        stack.frame = CGRect(x: 20, y: view.frame.height - 90, width: view.frame.width - 40, height: 50)
        stack.layer.cornerRadius = 25
        stack.addArrangedSubview(UIView())
        stack.addArrangedSubview(btn1)
        stack.addArrangedSubview(btn2)
        stack.addArrangedSubview(btn3)
        stack.addArrangedSubview(btn4)
        stack.addArrangedSubview(UIView())
        return stack
    }()
    
    // Tab buttons
    private lazy var btn1 = getButton(icon: "house", tag: 0, action: action, opacity: 1)
    private lazy var btn2 = getButton(icon: "magnifyingglass", tag: 1, action: action, opacity: 1)
    private lazy var btn3 = getButton(icon: "message", tag: 2, action: action, opacity: 1)
    private lazy var btn4 = getButton(icon: "arrow.down.to.line", tag: 3, action: action, opacity: 1)
    
    let vc1 = UINavigationController(rootViewController: HomeController())
    let vc2 = UINavigationController(rootViewController: SearchController())
    let vc3 = UINavigationController(rootViewController: Conversation())
    let vc4 = UINavigationController(rootViewController: DownloadsController())
    
    // actions
    private lazy var action = UIAction { [weak self] sender in
        guard let sender = sender.sender as? UIButton, let self = self else { return }
        
        self.selectedIndex = sender.tag
        self.setOpacity(tag: sender.tag)
    }
 
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customBar)
        tabBar.isHidden = true
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide double nav bar
        navigationController?.navigationBar.isHidden = true
    }

    private func getButton(icon: String, tag: Int, action: UIAction, opacity: Float = 0.5) -> UIButton {
        return {
            $0.setImage(UIImage(systemName: icon), for: .normal)
            $0.tag = tag
            $0.tintColor = .black
            $0.layer.opacity = opacity
            return $0
        }(UIButton(primaryAction: action))
    }
    
    private func setOpacity(tag: Int) {
        [btn1, btn2, btn3, btn4].forEach { button in
            if button.tag != tag {
                
                UIView.animate(withDuration: 1) { [weak self] in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        button.layer.opacity = 0.5
                        button.tintColor = .black
                    }
                }
                // addinition any customs
            } else {
                
                UIView.animate(withDuration: 1) { [weak self] in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        switch button.tag {
                        case 0: button.setImage(UIImage(systemName: "house.fill"), for: .normal)
                        case 1: button.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
                        case 2: button.setImage(UIImage(systemName: "message.fill"), for: .normal)
                        case 3: button.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
                        default:
                            break
                        }
                        button.layer.opacity = 1
                        button.tintColor = .systemRed
                    }
                }
            }
        }
    }
}



