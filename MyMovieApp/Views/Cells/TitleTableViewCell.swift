//
//  TitleTableViewCell.swift
//  MyMovieApp
//
//  Created by Macbook on 5/5/24.
//

import UIKit
import SDWebImage

final class TitleTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "TitleTableViewCell"
    
    // MARK: - UI Components
    private let titlesPosterImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "message"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ERROR"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Cell Configure
    public func configure(with model: TitleViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        
        self.titlesPosterImageView.sd_setImage(with: url, completed: nil)
        self.titleLabel.text = model.titleName
    }
    
    // MARK: - Setup UI
    private func setupConstraints() {
        
        contentView.addSubview(titlesPosterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        NSLayoutConstraint.activate([
            self.titlesPosterImageView.widthAnchor.constraint(equalToConstant: 100),
            self.titlesPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.titlesPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.titlesPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            self.titleLabel.leadingAnchor.constraint(equalTo: self.titlesPosterImageView.trailingAnchor, constant: 20),
            self.titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            self.playTitleButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
