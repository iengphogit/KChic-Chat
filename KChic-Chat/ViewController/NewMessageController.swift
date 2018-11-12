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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.fetchUsers()
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (DataSnapshot) in
            
            let dictionary = DataSnapshot.value as? [String: AnyObject]
            let user = UserModel()
            
            user.name = dictionary!["name"] as? String
            user.username = dictionary!["username"] as? String
            self.users.append(user)
            print(user.name!, user.username!)
            
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
        
        cell.textLabel?.text = users[indexPath.row].name
        cell.detailTextLabel?.text = users[indexPath.row].username
        return cell
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }

}
