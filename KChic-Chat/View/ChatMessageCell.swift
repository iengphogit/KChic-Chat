//
//  ChatMessageCellCollectionViewCell.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/16/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    var chatLogController:ChatLogViewController?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    static let blueColor = UIColor.init(netHex: 0x44abff)
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-ios")
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var playIcon:UIImageView = {
        let playIcon = UIImageView()
        playIcon.image = UIImage(named: "icons8-play-filled-50")
        playIcon.isUserInteractionEnabled = true
        playIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.playIconHandler)))
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        return playIcon
    }()
    
    @objc func playIconHandler(_ sender: UITapGestureRecognizer){
        chatLogController?.performPlayIconHandler(sender)
    }
    
    let seekBar:UIProgressView = {
        var seekBar = UIProgressView()
        seekBar.progressTintColor = UIColor.blue
        seekBar.trackTintColor = UIColor.white
        seekBar.translatesAutoresizingMaskIntoConstraints = false
        return seekBar
    }()
    
    let activityView:UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    lazy var voicePlayer: UIView = {
        let view = UIView()
        view.addSubview(playIcon)
        playIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        playIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        playIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        view.addSubview(activityView)
        activityView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        view.addSubview(seekBar)
        seekBar.leftAnchor.constraint(equalTo: playIcon.rightAnchor, constant: 0).isActive = true
        seekBar.rightAnchor.constraint(equalTo: activityView.leftAnchor, constant: -8).isActive = true
        seekBar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        bubbleView.addSubview(voicePlayer)
        voicePlayer.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
//        voicePlayer.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        voicePlayer.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        voicePlayer.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        
        //BubbleView Constraint
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor)
//        bubbleLeftAnchor?.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor =  bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleHeightAnchor = bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor)
        bubbleHeightAnchor?.isActive = true
        
        //TextView Constraint
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //ProfileImageView Constraint
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
