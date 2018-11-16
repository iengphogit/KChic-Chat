//
//  ChatLogViewController.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/15/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit
import Firebase
class ChatLogViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var user:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.collectionView.backgroundColor = .white
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.height - 1, height: 20)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
//        layout.scrollDirection = .vertical
        
        
        
        //collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        
            navigationItem.title = user?.name ?? "unknow"
        
        setupContainerView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.green
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.height, height: 80)
    }
    
   lazy var sendBtn:UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Send", for: UIControl.State.normal)
    btn.addTarget(self, action: #selector(self.sendMessageHandler), for: UIControl.Event.touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc func sendMessageHandler() {
        print(messageTextField.text!)
        let toId = user!.id!
        let fromId = Auth.auth().currentUser?.uid ?? ""
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let values = ["text":messageTextField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
        }
        
        
        messageTextField.text = ""
    }
    
    lazy var messageTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter message..."
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessageHandler()
        return true
    }
    
    let separatorLineView:UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(netHex: 0xb2b2b2)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    func setupContainerView(){
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        containerView.addSubview(sendBtn)
        sendBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        containerView.addSubview(messageTextField)
        
        messageTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        messageTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: sendBtn.leftAnchor).isActive = true
        
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }

}


extension ChatLogViewController {
    
}
