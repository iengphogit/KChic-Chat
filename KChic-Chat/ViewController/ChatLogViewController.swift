//
//  ChatLogViewController.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/15/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
class ChatLogViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    let cellId = "cellId"
    let fileName:String = "audioFile.m4a"
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var user:UserModel? {
        didSet{
            navigationItem.title = user?.name ?? "unknow"
            observeMessages()
        }
    }
    var messages = [MessageModel]()
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
            return
        }
        
        let userMessageRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessageRef.observe(.childAdded, with: { (DataSnapshot) in
            
            let messageId = DataSnapshot.key
            self.fetchMessagesWithMessageId(messageId)
            
        }, withCancel: nil)
        
    }
    
    private func fetchMessagesWithMessageId(_ messageId: String){
        
        let messageRef = Database.database().reference().child("messages").child(messageId)
        messageRef.observeSingleEvent(of: DataEventType.value, with: { (messagesSnapshot) in
            
            guard let dictionary = messagesSnapshot.value as? [String: AnyObject] else { return }
            
            let message = MessageModel()
            message.text = dictionary["text"] as? String
            message.fromId = dictionary["fromId"] as? String
            message.toId = dictionary["toId"] as? String
            message.timestamp = dictionary["timestamp"] as? Int
            message.voiceUrl =  dictionary["voiceUrl"] as? String
            message.duration = dictionary["duration"] as? Double
            
            if message.chatPartnerId() == self.user?.id {
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 58, right: 0)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .white
        self.collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView.keyboardDismissMode = .interactive
        
        //        setupContainerView()
        //        setupKeybaordservers()
        
        setupRecorder()
    }
    
    
    func getDocumentDirection() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupRecorder(){
        let audioFilename = getDocumentDirection().appendingPathComponent(fileName)
        let recorderString = [AVFormatIDKey: kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey: 320000,
                              AVNumberOfChannelsKey: 2,
                              AVSampleRateKey: 44100.2] as [String:Any]
        do{
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recorderString)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        }catch{
            print(error)
        }
    }
    
    func setupPlayer(){
        let audioFilename = getDocumentDirection().appendingPathComponent(fileName)
        do{
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 5.0
        }catch{
            print(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let audioFilename = getDocumentDirection().appendingPathComponent(fileName)
        
        let voiceName = NSUUID().uuidString + ".m4a"
        let ref = Storage.storage().reference().child("message-voices").child(voiceName)
        //        guard let data = NSData(contentsOf: audioFilename) else {
        //            return
        //        }
        ref.putFile(from: audioFilename, metadata: nil) { (rMetadata, rError) in
            if rError != nil {
                print("Failed")
            }
            
            print("Success!")
            
            self.sendMessageVoiceHandler(voiceName)
            
        }
    }
    
    func sendMessageVoiceHandler(_ voiceName:String) {
        let toId = user!.id!
        let fromId = Auth.auth().currentUser?.uid ?? ""
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        do{
         soundPlayer = try AVAudioPlayer(contentsOf: getDocumentDirection().appendingPathComponent(fileName))
        }catch{
            print(error)
        }
        
        let values = ["voiceUrl": voiceName, "toId": toId, "fromId": fromId, "timestamp": timestamp, "duration": soundPlayer.duration] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error)
                return
            }
            
            self.messageTextField.text = nil
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
        }
        
        
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    
    
    lazy var recorderImg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "microphone")
        imgView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap))
        imgView.addGestureRecognizer(tapGesture)
        
        let longGesutre = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        imgView.addGestureRecognizer(longGesutre)
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    @objc func normalTap(_ sender: UIGestureRecognizer){
        print("normalTap")
    }
    
    @objc func longTap(_ sender: UIGestureRecognizer){
        guard let soundRec = soundRecorder else {return}
        
        if ( sender.state == .began){
            //start tap gesture
            print("longTap began")
            soundRec.record()
        }else if (sender.state == .ended) {
            //ending tap gesture
            print("longTap ended")
            soundRec.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
            self.sendAudioDataToFirebase()
        }
    }
    
    func sendAudioDataToFirebase(){
        
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
        
        containerView.addSubview(recorderImg)
        recorderImg.widthAnchor.constraint(equalToConstant: 32).isActive = true
        recorderImg.heightAnchor.constraint(equalToConstant: 32).isActive = true
        recorderImg.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        recorderImg.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        messageTextField.leftAnchor.constraint(equalTo: recorderImg.rightAnchor , constant: 16).isActive = true
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.collectionViewLayout.invalidateLayout()
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
        if let message = message.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message).width + 32
        }
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
        
        
        if let voiceUrl = message.voiceUrl {
            cell.voicePlayer.isHidden = false
            cell.bubbleHeightAnchor?.constant = -40
            cell.textView.isHidden = true
            guard let duration = message.duration else {
                return
            }
            let maxLenght = 200.00
            if duration <= 40 {
                cell.bubbleWidthAnchor?.constant = CGFloat(((maxLenght * (2/3)) + duration))
            }else if duration <= 20 {
                cell.bubbleWidthAnchor?.constant = CGFloat(((maxLenght / 3) + duration))
            }else{
                let widthNum = (maxLenght * duration) / 60
                cell.bubbleWidthAnchor?.constant = CGFloat(widthNum)
            }
            
        }else{
            cell.voicePlayer.isHidden = true
            cell.textView.isHidden = false
            cell.bubbleHeightAnchor?.constant = 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        if let text = messages[indexPath.row].text {
            height = self.estimateFrameForText(text: text).height + 20
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
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
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
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
