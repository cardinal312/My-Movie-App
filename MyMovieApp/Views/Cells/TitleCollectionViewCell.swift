//
//  TitleCollectionViewCell.swift
//  MyMovieApp
//
//  Created by Macbook on 5/5/24.
//

import UIKit
import SDWebImage

final class TitleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier = "TitleCollectionViewCell"
    
    // MARK: - UI Components
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(posterImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.posterImageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        
        self.posterImageView.sd_setImage(with: url, completed: nil)
    }
    
    
}
