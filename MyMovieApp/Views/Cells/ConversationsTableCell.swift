//
//  ConversationsTableCell.swift
//  MyMovieApp
//
//  Created by Macbook on 10/5/24.
//

import UIKit

final class ConversationsTableCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "ConversationsTableCell"
    
    // MARK: - UI Components
    private let userImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.fill"))
        iv.backgroundColor = .white
        iv.tintColor = .black
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.red.cgColor
        return iv
    }()
    
    private lazy var userInfoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.text = "Loading"
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    // MARK: - Cell Methods
    public func configure(with model: CurrentUser) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.userInfoLabel.text = model.username
            guard let url = URL(string: model.avatar) else { return }
            self.userImageView.sd_setImage(with: url)
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.userImageView.layer.cornerRadius = 33.333
        
        self.contentView.addSubview(userImageView)
        self.contentView.addSubview(userInfoLabel)
        
        NSLayoutConstraint.activate([
            self.userImageView.heightAnchor.constraint(equalToConstant: 70),
            self.userImageView.widthAnchor.constraint(equalToConstant: 70),
            self.userImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            self.userImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            self.userInfoLabel.leadingAnchor.constraint(equalTo: self.userImageView.trailingAnchor, constant: 40),
            self.userInfoLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
