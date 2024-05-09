//
//  HomeController.swift
//  MyMovieApp
//
//  Created by Macbook on 29/4/24.
//

import UIKit

fileprivate enum Sections: Int {
    case TrendingMovies = 0
    case TrentingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

final class HomeController: UIViewController {
    
    // MARK: - Variables
    private let sectionTitles = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    private var randomTrendingMovie: Title?
    
    // MARK: - UI Components
    private var heroHeaderView: HeroHeaderView?
    
    private lazy var homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        //table.bounces = false
        table.showsVerticalScrollIndicator = false
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()
    
    // MARK: Lifecycleoverride
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.configureNavBar()
        self.setupUI()
        self.configureHeroHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    private func configureHeroHeaderView() {
        heroHeaderView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = heroHeaderView
        
        APICaller.shared.getTrendingMovie { [weak self] results in
            guard let self = self else { return }
            
            switch results {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self.randomTrendingMovie = selectedTitle
                self.heroHeaderView?.configure(with: TitleViewModel(posterURL: selectedTitle?.poster_path ?? "", titleName: selectedTitle?.original_title ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.addSubview(homeFeedTable)
        self.homeFeedTable.delegate = self
        self.homeFeedTable.dataSource = self
        
        NSLayoutConstraint.activate([
            self.homeFeedTable.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.homeFeedTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.homeFeedTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.homeFeedTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func configureNavBar() {
        var image = UIImage(named: .homeLeftBarButton)
        image = image?.withRenderingMode(.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(didTapAppIconButton))
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = leftBarButtonItem
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style:
                .done, target: self, action: #selector(didTaprightBarButton))
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func didTapAppIconButton() {
        let shareActivity = UIActivityViewController(activityItems: ["Please share with My Movie App with your friends! 😍🔥"], applicationActivities: nil)
        if let vc = UIApplication.shared.windows.first?.rootViewController{
            vc.present(shareActivity, animated: true, completion: nil)
        }
    }
    
    @objc private func didTaprightBarButton() {
        let vc = ProfileController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else { return UITableViewCell() }
        
        // MARK: - CollectionTableViewCellDelegate
        cell.delegate = self
        
        // MARK: - API CALLS
        switch indexPath.section {
            
        case Sections.TrendingMovies.rawValue:
    
            APICaller.shared.getTrendingMovie { [weak self] results in
                guard let self = self else { return }
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrentingTv.rawValue:
            
            APICaller.shared.getTrendingTv { [weak self] results in
                guard let self = self else { return }
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Popular.rawValue:
            
            APICaller.shared.getPopular { [weak self] results in
                guard let self = self else { return }
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Upcoming.rawValue:
            
            APICaller.shared.getUpcomingMovies { [weak self] results in
                guard let self = self else { return }
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            
            APICaller.shared.getTopRated { [weak self] results in
                guard let self = self else { return }
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: Int(header.bounds.origin.x + 15), y: Int(header.bounds.origin.y), width: 100, height: Int(header.bounds.height))
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    // MARK: - Scroll View Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

// MARK: CollectionTableViewCellDelegate
extension HomeController: CollectionTableViewCellDelegate {
    
    func collectionTableViewCellDidTapCell(_ cell: CollectionTableViewCell, viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let vc = TitlePreviewController()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
