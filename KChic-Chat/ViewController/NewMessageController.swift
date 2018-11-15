//
//  NewMessageController.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/12/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit
import Firebase
class NewMessageController: UITableViewController {
    var users = [UserModel]()
    let cellId: String = "cellId"
    
    //let users = [UserModel(name: "name1", username: "test1"), UserModel(name: "name2", username: "test2")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchUsers()
    }
    
    func fetchUsers() {
        
        Database.database().reference().child("users").observe(.childAdded, with: { (DataSnapshot) in
            
            let dictionary = DataSnapshot.value as? [String: AnyObject]
            let user = UserModel()
            user.id = DataSnapshot.key
            user.name = dictionary!["name"] as? String
            user.username = dictionary!["username"] as? String
            user.profileImageUrl = dictionary!["profileImageUrl"] as? String
            self.users.append(user)
//            print(user.name!, user.username!)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }) { (Error) in
            print(Error.localizedDescription)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserCell
        
        cell.textLabel?.text = users[indexPath.row].name
        cell.detailTextLabel?.text = users[indexPath.row].username
        if let profileImageUrl = users[indexPath.row].profileImageUrl {
            let url = URL(string: profileImageUrl)
            cell.imageView?.contentMode = .scaleAspectFit
            cell.profileImageView.downloadImageWithUrl(url: url!)
        }
        
        return cell
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var messageController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        let user = self.users[indexPath.row]
        self.messageController?.showChatController(user: user)
    }
    
    

}
