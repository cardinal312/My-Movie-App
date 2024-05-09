//
//  ProfileController.swift
//  MyMovieApp
//
//  Created by Macbook on 8/5/24.
//

import UIKit
import SDWebImage

final class ProfileController: UIViewController {
    
    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.fill"))
        iv.backgroundColor = .white
        iv.tintColor = .black
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.red.cgColor
        iv.layer.cornerRadius = 100
        return iv
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        ip.allowsEditing = false
        ip.mediaTypes = ["public.image", "public.movie"]
        return ip
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "Loading"
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .gray
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
        self.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Profile"
        self.setupUI()
    
        AuthManager.shared.fetchUser { [weak self] user, _  in
            guard let self = self else { return }
            guard let user = user else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.infoLabel.text = "\(user.username)\n\(user.email)\n\(user.avatar.description)"
                print("\(user.username)\n\(user.email)\n\(user.avatar.description)")
                
                guard let url = URL(string: user.avatar) else { return }
                self.profileImageView.sd_setImage(with: url)
                
                guard let imageData = UserDefaults.standard.value(forKey: "avatar") as? Data else { return }
            }
        }
    }
    
    // MARK: - Selectors
    @objc private func didTapLogout() {
        UserDefaults.standard.removeObject(forKey: "avatar")
        
        AuthManager.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogoutErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        // MARK: - UserDefaults, signOut Setting
            UserDefaults.standard.set(true, forKey: "signOut")
        }
    }
    
    @objc private func didTapImageView() {
            DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(self.imagePickerController, animated: true)
        }
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - UImagePicker Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.mediaType] as? String == "public.image" {
            //pass handle photo function
            self.handlePhoto(info)
        } else {
            print("Can't choose mediatype")
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Images
    private func handlePhoto(_ info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            UserDefaults.standard.register(defaults: ["avatar":image.jpegData(compressionQuality: 100)!])
            UserDefaults.standard.set(image.jpegData(compressionQuality: 100), forKey: "avatar")
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.profileImageView.image = image
            }
            
            let pressedImage = image.jpegData(compressionQuality: 0.1 /*compressionQuality*/)
            
            guard let imageData = pressedImage else { return }
            
            StorageManager.shared.uploadProfilePicture(with: imageData, fileName: image.description) { [weak self] results in
                guard let self = self else { return }
                
                switch results {
                case .success(let imageUrl):
                guard let url = URL(string: imageUrl) else { return }
                    
                    //SAVE IMAGE TO LOCAL STORAGE
                    DispatchQueue.main.async { [weak self] in
                        self?.profileImageView.sd_setImage(with: url)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setupUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        profileImageView.addGestureRecognizer(tap)
        
        view.addSubview(profileImageView)
        view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            
            self.profileImageView.widthAnchor.constraint(equalToConstant: 200),
            self.profileImageView.heightAnchor.constraint(equalToConstant: 200),
            self.profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            self.infoLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 30),
            self.infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.infoLabel.widthAnchor.constraint(equalToConstant: 250),
            self.infoLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
    
    

