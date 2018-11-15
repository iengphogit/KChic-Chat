//
//  ViewController.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/8/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit
import Firebase
class MessagesController: UITableViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "icons8-create-50")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.handleNewMessage))
        
        checkIfUserIsLoggedIn()
    }
    
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }else{
            self.fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle(){
        
        guard  let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observe(DataEventType.value, with: { (DataSnapshot) in
            
            if let dictionary = DataSnapshot.value as? [String: AnyObject] {
//                self.navigationItem.title = dictionary["name"] as? String
                
                let user = UserModel()
                user.name = dictionary["name"] as? String
                user.username = dictionary["username"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.setupNavBarWithUser(user: user)
            }
            
            
        }, withCancel: nil)
        
    }
    
    func setupNavBarWithUser(user: UserModel){
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.backgroundColor = .red
        
        let profileImageView = UIImageView()
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.downloadImageWithUrl(url: URL(string: profileImageUrl)!)
        }
        
        let stackView = UIStackView()
        titleView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(profileImageView)
        
        //set constraint
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        let profileTitle = UILabel()
        stackView.addArrangedSubview(profileTitle)
        profileTitle.text = user.name
        profileTitle.numberOfLines = 1
//        profileTitle.lineBreakMode = .byWordWrapping
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showChatController))
        profileTitle.isUserInteractionEnabled = true
        profileTitle.addGestureRecognizer(tap)
        
        self.navigationController?.view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
        
        self.navigationItem.titleView = titleView
        
    }
    
    @objc func showChatController(){
        let clVC = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        clVC.view.backgroundColor = .red
        navigationController?.pushViewController(clVC, animated: true)
    }
    
    @objc func handleNewMessage(){
        let vc = NewMessageController()
        let navigationVC = UINavigationController(rootViewController: vc)
        self.present(navigationVC, animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginController = LoginViewController()
            loginController.messageController = self
            present(loginController, animated: false, completion: nil)
        }catch {
            handleError(error)
        }
    }
    


}

