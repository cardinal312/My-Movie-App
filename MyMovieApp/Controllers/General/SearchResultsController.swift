//
//  SearchResultsController.swift
//  MyMovieApp
//
//  Created by Macbook on 5/5/24.
//

import UIKit

protocol SearchResultsControllerDelegate: AnyObject {
    func searchResultsControllerDelegateDidTapItem(_ viewModel: TitlePreviewViewModel)
}

final class SearchResultsController: UIViewController {

    // MARK: - Variables
    public var titles: [Title] = []
    public weak var delegate: SearchResultsControllerDelegate?
    
    // MARK: - UI Components
    public lazy var searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.view.addSubview(searchResultsCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultsController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Collection View Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        
        // MARK: - API CALLS
        APICaller.shared.getMovie(with: titleName) { [weak self] results in
                guard let self = self else { return }
                
                switch results {
                case .success(let videoElement):
                    
                    DispatchQueue.main.async { [weak self] in
                        let vc = TitlePreviewController()
                        vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    delegate?.searchResultsControllerDelegateDidTapItem(TitlePreviewViewModel(title: title.original_title ?? title.original_name ?? "", youtubeView: videoElement, titleOverview: title.overview ?? ""))
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
