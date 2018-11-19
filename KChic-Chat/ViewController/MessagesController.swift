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
    let cellId = "cellId"
    var messages = [MessageModel]()
    var messagesDictionary = [String: MessageModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "icons8-create-50")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.handleNewMessage))
        
        checkIfUserIsLoggedIn()
        //observeMessages()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: self.cellId)
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        messages.removeAll()
        messagesDictionary.removeAll()
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(DataEventType.childAdded, with: { (DataSnapshot) in
            
            let messageId = DataSnapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (DataSnapshot) in
                
                if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                    let msg:MessageModel = MessageModel()
                    msg.fromId = dictionary["fromId"]! as? String
                    msg.text = dictionary["text"] as? String
                    msg.timestamp = dictionary["timestamp"] as? Int
                    msg.toId = dictionary["toId"] as? String
                    //self.messages.append(msg)
                    
                    self.messagesDictionary[msg.chatPartnerId()!] = msg
                    self.messages = Array(self.messagesDictionary.values)
                    
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return message1.timestamp! > message2.timestamp!
                    })
                    
                    /*
                    self.timer?.invalidate()
                                    print("just canceled our timer")
                    self.timer? = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                                    print("schedule is a table reload in 0.1 sec")
 
                    */
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        
    }
    
    var timer: Timer?
    @objc func handleReloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chartParnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chartParnerId)
        ref.observeSingleEvent(of: DataEventType.value, with: { (DataSnapshot) in
            guard let dictionary = DataSnapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = UserModel()
            user.id = chartParnerId
            user.name = dictionary["name"] as? String
            user.username = dictionary["username"] as? String
            user.profileImageUrl = dictionary["profileImageUrl"] as? String
            
            self.showChatController(user: user)
            
            
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
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
                user.id = DataSnapshot.key
                user.name = dictionary["name"] as? String
                user.username = dictionary["username"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.setupNavBarWithUser(user: user)
            }
            
            
        }, withCancel: nil)
        
    }
    
    func setupNavBarWithUser(user: UserModel){
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.backgroundColor = .red
        
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "logo-ios")
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
        
        /*
         
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showChatController))
        profileTitle.isUserInteractionEnabled = true
        profileTitle.addGestureRecognizer(tap)
        
        self.navigationController?.view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
 
        */
        
        self.navigationItem.titleView = titleView
        
    }
    
    @objc func showChatController(user:UserModel){
        let clVC = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        clVC.user = user
        navigationController?.pushViewController(clVC, animated: true)
    }
    
    @objc func handleNewMessage(){
        let vc = NewMessageController()
        vc.messageController = self
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

