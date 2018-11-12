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
            
        }
    }
    
    @objc func handleNewMessage(){
        print("new msg")
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginController = LoginViewController()
            present(loginController, animated: false, completion: nil)
        }catch {
            handleError(error)
        }
    }
    


}

