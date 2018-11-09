//
//  SignUpViewController.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/9/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    var userNamer: String = ""
    var userPassword: String = ""
    var userConfirmPassword: String = ""
    var isAttemed: Bool = false
    
    var navBar: UINavigationBar = {
        let nav = UINavigationBar()
        let mframe = UIApplication.shared.statusBarFrame.size
        let frame = CGRect(x: 0, y: mframe.height, width: mframe.width, height: 44)
        let navItem = UINavigationItem(title: "Sign Up")
        nav.frame = frame
        nav.setItems([navItem], animated: false)
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(navBar)
        
    }
}
