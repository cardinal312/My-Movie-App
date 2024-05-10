//
//  ChatController.swift
//  MyMovieApp
//
//  Created by Macbook on 2/5/24.
//

import UIKit
import JGProgressHUD

final class Conversation: UIViewController {

    // MARK: - Variables
    private let spinner = JGProgressHUD(style: .dark)
    private var users: [CurrentUser] = []
    
    // MARK: - UI Components
    private lazy var conversationsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        //table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(ConversationsTableCell.self, forCellReuseIdentifier: ConversationsTableCell.identifier)
        table.delegate = self
        table.dataSource = self
        //table.isHidden = true
        return table
    }()
    
    private lazy var noConversationsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.tintColor = .gray
        label.isHidden = true
        return label
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .systemBackground
        title = "Chats"
        self.view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapNewConversation))
        
        self.view.addSubview(conversationsTableView)
        self.view.addSubview(noConversationsLabel)
        self.fetchCorversations()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.conversationsTableView.frame = view.bounds
    }
    
    //MARK: Functions
    @objc private func didTapNewConversation() {
        let vc = NewConversationController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
    
    private func fetchCorversations() {
        self.conversationsTableView.isHidden = true
        self.spinner.show(in: self.view)
        
        DataBaseManager.shared.fetchAllUsers { [weak self] users in
            self?.users = users
            DispatchQueue.main.async { [weak self] in
                
                self?.spinner.textLabel.text = "Loading"
                
                self?.conversationsTableView.reloadData()

                self?.conversationsTableView.isHidden = false
                self?.spinner.dismiss()
            }
        }
    }
}

extension Conversation: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsTableCell.identifier, for: indexPath) as? ConversationsTableCell else { return UITableViewCell() }
        
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: self.users[indexPath.row])
        
//        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = false
        let vc = ChatController()
        let usersdata =  self.users[indexPath.row]
        vc.title = usersdata.username
        vc.avatar = usersdata.avatar
        vc.otherId = usersdata.id
        vc.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}
