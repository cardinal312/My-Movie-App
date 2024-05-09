//
//  TitlePreviewController.swift
//  MyMovieApp
//
//  Created by Macbook on 6/5/24.
//

import UIKit
import WebKit

final class TitlePreviewController: UIViewController {
        
    // MARK: - UI Components
    private let webView: WKWebView = {
        let wv = WKWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Error"
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "Error"
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .red
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.addSubview(webView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(overviewLabel)
        self.view.addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            
            self.webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            self.webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.webView.heightAnchor.constraint(equalToConstant: 300),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.webView.bottomAnchor, constant: 20),
            self.titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            self.overviewLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15),
            self.overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            self.downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.downloadButton.topAnchor.constraint(equalTo: self.overviewLabel.bottomAnchor, constant: 25),
            self.downloadButton.widthAnchor.constraint(equalToConstant: 140),
            self.downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Method for pass data
    func configure(with model: TitlePreviewViewModel) {
        self.titleLabel.text = model.title
        self.overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
        self.webView.load(URLRequest(url: url))
    }
}
