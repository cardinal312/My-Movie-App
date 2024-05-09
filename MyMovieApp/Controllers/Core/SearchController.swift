//
//  SearchController.swift
//  MyMovieApp
//
//  Created by Macbook on 2/5/24.
//

import UIKit

final class SearchController: UIViewController {

    // MARK: - Variables
    private var titles: [Title] = []
    
    // MARK: - UI Components
    private lazy var discoverTable: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsController())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.view.addSubview(discoverTable)
        
        
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.tintColor = .white
        
        self.fetchDiscoverMovies()
        
        self.searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.discoverTable.frame = view.bounds
    }
    
    // MARK: - API Calls
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] results in
            guard let self = self else { return }
            switch results {
            case .success(let titles):
                self.titles = titles
                
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let titles = titles[indexPath.row]
        let model = TitleViewModel(posterURL: titles.poster_path ?? "", titleName: titles.original_name ?? titles.original_title ?? "Unknown name")
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else { return }
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
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

    //MARK: - Search Controller Methods
extension SearchController: UISearchResultsUpdating, SearchResultsControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count >= 3, let resultsController = searchController.searchResultsController as? SearchResultsController else { return }
        
        // MARK: - SearchResultsControllerDelegate implemetation
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { [weak self] results in
            guard let self = self else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch results {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print("Searching query error --->>> \(error.localizedDescription) <<<---")
                }
            }
        }
    }
    
    // MARK: - SearchResultsControllerDelegate Method
    func searchResultsControllerDelegateDidTapItem(_ viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
    
