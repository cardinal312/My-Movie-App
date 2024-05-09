//
//  DownloadsController.swift
//  MyMovieApp
//
//  Created by Macbook on 2/5/24.
//

import UIKit

final class DownloadsController: UIViewController {

    // MARK: - Variables
    private var titles: [TitleItem] = []
        
    // MARK: - UI Components
    private lazy var downloadedTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = "Downloads"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.tintColor = .white
        self.setupUI()
        self.fetchLocalStorageFromDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { [weak self] _ in
            guard let self else { return }
            self.fetchLocalStorageFromDownload()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.downloadedTableView.frame = view.bounds
    }
    
    private func fetchLocalStorageFromDownload() {
        CoreDataManager.shared.fetchingTitlesFromDataBase { [weak self] results in
            guard let self else { return }
            switch results {
            case .success(let titles):
                DispatchQueue.main.async { [weak self] in
                    self?.titles = titles
                    self?.downloadedTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.addSubview(downloadedTableView)
    }
}

extension DownloadsController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(posterURL: title.poster_path ?? "", titleName: (title.original_title ?? title.original_name) ?? "Unknown title name"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tableView.deselectRow(at: indexPath, animated: true)
            CoreDataManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] results in
                guard let self else { return }
                switch results {
                case .success(_): 
                    print("Deleted from the core data")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.titles.remove(at: indexPath.row)

                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default: break
        }
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
