//
//  NewConversationController.swift
//  MyMovieApp
//
//  Created by Macbook on 7/5/24.
//

import UIKit
import JGProgressHUD

final class NewConversationController: UIViewController {
    
    // MARK: - Variables
    private let spinner = JGProgressHUD()
    
    // MARK: - UI Components
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users..."
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var usersTableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.delegate = self
        tv.dataSource = self
        tv.isHidden = true
        return tv
    }()
    
    private lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No results"
        label.textColor = .green
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapDismissButton))
        
        view.addSubview(usersTableView)
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.usersTableView.frame = view.bounds
    }
    // MARK: - Setup UI
    
    // MARK: - _ Methods
    @objc private func didTapDismissButton() {
        dismiss(animated: true, completion: nil)
    }
    

}

extension NewConversationController: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //
    }
    
    //MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "New users"
        return cell
    }
    
}

