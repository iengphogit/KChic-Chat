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
        tableView.register(Usercell.self, forCellReuseIdentifier: cellId)
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (DataSnapshot) in
            
            let dictionary = DataSnapshot.value as? [String: AnyObject]
            let user = UserModel()
            
            user.name = dictionary!["name"] as? String
            user.username = dictionary!["username"] as? String
            user.profileImageUrl = dictionary!["profileImageUrl"] as? String
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! Usercell
        
        cell.textLabel?.text = users[indexPath.row].name
        cell.detailTextLabel?.text = users[indexPath.row].username
        if let profileImageUrl = users[indexPath.row].profileImageUrl {
            let url = URL(string: profileImageUrl)
            cell.imageView?.contentMode = .scaleAspectFit
            downloadImage(from: url!, imageV: cell.profileImageView )
        }
        
        return cell
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func downloadImage(from url: URL, imageV:UIImageView){
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                imageV.image = UIImage(data: data)!
                print("Download done")
                
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}

class Usercell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "logo-ios")
        img.layer.cornerRadius = 26
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 72, y: textLabel?.frame.origin.y ?? 0 , width: (textLabel?.frame.size.width)!, height: textLabel?.frame.size.height ?? 0)
        
        detailTextLabel?.frame = CGRect(x: 72, y: (detailTextLabel?.frame.origin.y)!, width: detailTextLabel?.frame.size.width ?? 0, height: detailTextLabel?.frame.size.height ?? 0)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
//        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
