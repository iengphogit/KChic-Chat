//
//  MessageModel.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/15/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit
import Firebase
class MessageModel: NSObject {
    var fromId:String?
    var text:String?
    var timestamp:Int?
    var toId:String?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ?  toId :  fromId
    }
}
