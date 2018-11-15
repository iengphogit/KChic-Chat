//
//  UserCell.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/15/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit
import Firebase
class UserCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "logo-ios")
        img.layer.cornerRadius = 26
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    
    var message: MessageModel? {
        didSet{
            
            self.detailTextLabel?.text = message?.text
            if let toId = message?.toId {
                
                let ref = Database.database().reference().child("users").child(toId)
                ref.observe(.value, with: { (DataSnapshot) in
                    if let dictionary = DataSnapshot.value as? [String:AnyObject] {
                        self.textLabel?.text = dictionary["name"] as? String
                        
                        if let profileImageUrl = dictionary["profileImageUrl"] {
                            self.profileImageView.downloadImageWithUrl(url: URL(string: profileImageUrl as! String)!)
                        }
                    }
                    
                }, withCancel: nil)
                
                
            }
            
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 72, y: textLabel?.frame.origin.y ?? 0 , width: (textLabel?.frame.size.width)!, height: textLabel?.frame.size.height ?? 0)
        
        detailTextLabel?.frame = CGRect(x: 72, y: (detailTextLabel?.frame.origin.y)!, width: detailTextLabel?.frame.size.width ?? 0, height: detailTextLabel?.frame.size.height ?? 0)
        
        
    }
    
    let timeLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "hh:mm:ss"
        lbl.textColor = UIColor.init(netHex: 0xb2b2b2)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        //        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
