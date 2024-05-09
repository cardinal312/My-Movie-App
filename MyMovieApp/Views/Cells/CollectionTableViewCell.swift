//
//  CollectionTableViewCell.swift
//  MyMovieApp
//
//  Created by Macbook on 4/5/24.
//

import UIKit

protocol CollectionTableViewCellDelegate: AnyObject {
    func collectionTableViewCellDidTapCell(_ cell: CollectionTableViewCell, viewModel: TitlePreviewViewModel)
}

final class CollectionTableViewCell: UITableViewCell {

    // MARK: - Variables
    static let identifier = "CollectionTableViewCell"
    private var titles: [Title] = []
    
    weak var delegate: CollectionTableViewCellDelegate?
    
    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = contentView.bounds
    }
    
    // MARK: - Data importing
    public func configure(with titles: [Title]) {
        self.titles = titles
        
        DispatchQueue.main.async { [weak self]  in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        
        CoreDataManager.shared.downloadTitleWith(model: titles[indexPath.row]) { [weak self] results in
            guard let self else { return }
            
            switch results {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                print("Downloaded to Database")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.contentView.addSubview(collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Collection View Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        // MARK: - SAVE IMAGES
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        // MARK: - YOUTUBE API CALLS
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] results in
            switch results {
            case .success(let videoElement):
                
                let title = self?.titles[indexPath.row]
                guard let stronSelf = self else { return }
                guard let titleOverview = title?.overview else { return }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.collectionTableViewCellDidTapCell(stronSelf, viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @available(iOS 16.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            
            if #available(iOS 16, *) {
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
                    guard let self = self else { return }
                    
                    // TODO: - Core Data
                    self.downloadTitleAt(indexPath: indexPaths[0])
                }
                return UIMenu(title: "", identifier: nil, options: .displayInline, children: [downloadAction])
            } else {
                
                // Fallback on earlier versions
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
                    guard let self = self else { return }
                    
                    // TODO: - Core Data
                    self.downloadTitleAt(indexPath: indexPaths[0])
                }
                return UIMenu(title: "", identifier: nil, options: .displayInline, children: [downloadAction])
            }
        }
        return config
    }
    
    
}
