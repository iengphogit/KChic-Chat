//
//  UserModel.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/12/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit

class UserModel:NSObject {
    var name: String?
    var username: String?
    var profileImageUrl: String?
    
    init(name:String?, username:String?){
        self.name = name
        self.username = username
    }
    
    override convenience init() {
        self.init(name: "", username: "")
    }
}
