//
//  WebViewController.swift
//  MyMovieApp
//
//  Created by Macbook on 30/4/24.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    // MARK: - Variables
    private let urlString: String
    
    // MARK: - UI Components
    private lazy var webView = WKWebView()
    
    // MARK: Lifecycle
    init(with urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        guard let url = URL(string: urlString) else {
            dismiss(animated: true, completion: nil)
            print(NetworkError.badUrl); return }
        
        self.webView.load(URLRequest(url: url))
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        self.view.addSubview(webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc private func  didTapDoneButton() {
        print("DEBUG PRINT:", "didTapDoneButton")
        self.dismiss(animated: true, completion: nil)
    }
}
