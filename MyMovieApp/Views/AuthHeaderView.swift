//
//  AuthHeaderView.swift
//  MyMovieApp
//
//  Created by Macbook on 29/4/24.
//

import UIKit

final class AuthHeaderView: UIView {
    
    // MARK: - UI Components
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: .loginLogo) // TODO: Should be use logo
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let titltLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "Error"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitltLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Error"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Lifecycle
    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        self.titltLabel.text = title
        self.subTitltLabel.text = subTitle
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    private func setupUI() {
        self.addSubview(logoImageView)
        self.addSubview(titltLabel)
        self.addSubview(subTitltLabel)
        
        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 16),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 115),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 115),
            
            self.titltLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 19),
            self.titltLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titltLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.subTitltLabel.topAnchor.constraint(equalTo: titltLabel.bottomAnchor, constant: 12),
            self.subTitltLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.subTitltLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
