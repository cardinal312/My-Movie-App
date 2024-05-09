//
//  HeroHeaderView.swift
//  MyMovieApp
//
//  Created by Macbook on 4/5/24.
//

import UIKit
import SDWebImage

final class HeroHeaderView: UIView {

    // MARK: - Variables
    
    // MARK: - UI Components
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downLoadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let heroImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "heroImage"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        self.addGradient()
        addSubview(playButton)
        addSubview(downLoadButton)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heroImageView.frame = bounds
    }
    
    // MARK: - Function for pass in data
    public func configure(with model: TitleViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        self.heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    // MARK: - Setup UI
    private func setupUI() {

        let playButtonConstraints = [
            self.playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            self.playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            self.playButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        let downloadButtonConstraints = [
            self.downLoadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            self.downLoadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            self.downLoadButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    // MARK: - Methods
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        gradientLayer.frame = bounds
        self.layer.addSublayer(gradientLayer)
    }
}
