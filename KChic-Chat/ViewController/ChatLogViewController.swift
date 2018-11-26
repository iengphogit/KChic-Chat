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
    var user:UserModel? {
        didSet{
            navigationItem.title = user?.name ?? "unknow"
            observeMessages()
        }
    }
    var messages = [MessageModel]()
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userMessageRef = Database.database().reference().child("user-messages").child(uid)
        userMessageRef.observe(.childAdded, with: { (DataSnapshot) in
            
            let messageId = DataSnapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: DataEventType.value, with: { (messagesSnapshot) in
                
                guard let dictionary = messagesSnapshot.value as? [String: AnyObject] else {return}
                
                let message = MessageModel()
                message.text = dictionary["text"] as? String
                message.fromId = dictionary["fromId"] as? String
                message.toId = dictionary["toId"] as? String
                message.timestamp = dictionary["timestamp"] as? Int
                print(message)
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 58, right: 0)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .white
        self.collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView.keyboardDismissMode = .interactive
        
//        setupContainerView()
//        setupKeybaordservers()
    }
    
    lazy var inputContainerView: UIView = {
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        containerView.addSubview(sendBtn)
        sendBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        containerView.addSubview(messageTextField)
        
        messageTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        messageTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        messageTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: sendBtn.leftAnchor).isActive = true
        
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get{
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeybaordservers() {
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybaordWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification){
        print("keyboardWillShow")
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            containerViewBottomAnchor?.constant = -keyboardHeight
            
            UIView.animate(withDuration: keyboardDuration as! Double) {
                self.view.layoutIfNeeded()
            }
            
            
        }
    }
    
    @objc
    func keybaordWillHide(notification: NSNotification){
        print("keybaordWillHide")
        containerViewBottomAnchor?.constant = 0
        
        if let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] {
            UIView.animate(withDuration: keyboardDuration as! Double) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        
        return cell
    }
    
    func setupCell(cell: ChatMessageCell, message: MessageModel){
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.downloadImageWithUrl(url: URL(string: profileImageUrl)! )
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        }else{
            cell.bubbleView.backgroundColor = UIColor.init(netHex: 0xf0f0f0)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        if let text = messages[indexPath.row].text {
            height = self.estimateFrameForText(text: text).height + 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size =  CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
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
            
            self.messageTextField.text = nil
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
        }
        
        
        
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
    
    let footerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(netHex: 0xdbffe1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    func setupContainerView(){
        let containerView = UIView()
        view.addSubview(footerView)
        view.addSubview(containerView)
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
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
        
        
        //FooterView Constraint
        footerView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        footerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
    }

}


extension ChatLogViewController {
    
}
