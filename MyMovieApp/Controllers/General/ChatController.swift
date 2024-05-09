//
//  ChatController.swift
//  MyMovieApp
//
//  Created by Macbook on 7/5/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

final class ChatController: MessagesViewController {
    
    //MARK: - Variables
    private var messages: [Message] = [] {
        didSet {
            self.updateMassases()
        }
    }
    
    let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Tommy")
    let otherSender = Sender(photoURL: "", senderId: "2", displayName: "Tommy")
    private var updateMassases: () -> () = {}
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        messagesCollectionView.keyboardDismissMode = .onDrag
        
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello world message")))
        messages.append(Message(sender: otherSender, messageId: "1", sentDate: Date(), kind: .text("Hello world message, Hello world message,Hello world message")))
        
        self.view.backgroundColor = .red
        
        messagesCollectionView.backgroundColor = .systemBackground
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        // reload collection
        messagesCollectionView.reloadDataAndKeepOffset()
//        self.updateMassases = { [weak self] in
//            self?.messagesCollectionView.reloadDataAndKeepOffset()
//        }
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        guard let tb = navigationController?.tabBarController as? MainTabBarControllerViewController else { return }
        tb.customBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let tb = navigationController?.tabBarController as? MainTabBarControllerViewController else { return }
        tb.customBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
    }
    
//    func keyboardWillShow(sender: NSNotification) {
//        self.view.frame.origin.y -= 150
//    }
//    func keyboardWillHide(sender: NSNotification) {
//        self.view.frame.origin.y += 150
//    }
}

extension ChatController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    var currentSender: MessageKit.SenderType {
        self.selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        self.messages.count
        
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.image = UIImage(named: .loginLogo)
        avatarView.tintColor = .red
    }

}

extension ChatController: MessageCellDelegate{
    
    func didTapBackground(in cell: MessageKit.MessageCollectionViewCell) {
        //
    }
    
    func didTapMessage(in cell: MessageKit.MessageCollectionViewCell) {
        //
    }
    
    func didTapAvatar(in cell: MessageKit.MessageCollectionViewCell) {
        print("Avatar Tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageKit.MessageCollectionViewCell) {
        //
    }
    
    func didTapCellBottomLabel(in cell: MessageKit.MessageCollectionViewCell) {
        //
    }
    
    func didTapMessageTopLabel(in cell: MessageKit.MessageCollectionViewCell) {
        //
    }
    
    func didTapMessageBottomLabel(in cell: MessageKit.MessageCollectionViewCell) {
        print("didTapMessageBottomLabel Tapped")
    }
    
    func didTapAccessoryView(in cell: MessageKit.MessageCollectionViewCell) {
        //
    }
    
    func didTapImage(in cell: MessageKit.MessageCollectionViewCell) {
        //
    }
    
    func didTapPlayButton(in cell: MessageKit.AudioMessageCell) {
        //
    }
    
    func didStartAudio(in cell: MessageKit.AudioMessageCell) {
        //
    }
    
    func didPauseAudio(in cell: MessageKit.AudioMessageCell) {
        //
    }
    
    func didStopAudio(in cell: MessageKit.AudioMessageCell) {
        //
    }
}
