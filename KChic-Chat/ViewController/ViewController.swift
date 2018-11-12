//
//  ViewController.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/8/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UITableViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginController = LoginViewController()
            present(loginController, animated: true, completion: nil)
        }catch {
            handleError(error)
        }
    }
    


}

