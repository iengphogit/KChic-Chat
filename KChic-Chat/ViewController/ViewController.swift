//
//  ViewController.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/8/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }
    
    @objc func handleLogout() {
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
    


}

