//
//  LoginViewController.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/9/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var userNameString: String?
    var userPasswordString: String?
    
    let formViewHolder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Montserrat-Black", size: 40)
        let myStringTitle = "KChicChat"
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: myStringTitle)
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(netHex: 0x53BAB6), range: NSRange(location: 5, length: 4))
        lbl.attributedText = attributeString
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let subTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Your KChicChat Messanger Privacy Tool!"
        lbl.textColor = UIColor.black
        lbl.font = UIFont(name: lbl.font.fontName, size: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let userNameLabel:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.text = "USERNAME"
        lbl.font = UIFont(name: lbl.font.fontName, size: 14)
        lbl.translatesAutoresizingMaskIntoConstraints =  false
        return lbl
        }()
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "User name"
        tf.borderStyle = .roundedRect
        tf.tag = 1
        tf.addTarget(self, action: #selector(onEditingChanged(_:)), for: .touchUpInside)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let userPasswordLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.gray
        lbl.text = "PASSWORD"
        lbl.font = UIFont(name: lbl.font.fontName, size: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let userPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "User password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(onEditingChanged(_:)), for: .touchUpInside)
        tf.tag = 2
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let loginButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Login", for: UIControl.State.normal)
        btn.backgroundColor = UIColor.init(netHex: 0x53BAB6)
        btn.layer.cornerRadius = 6
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(netHex: 0xf4feff)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.spacing = 3
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let dontHaveAccLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Don't have an account?"
        lbl.textColor = .gray
        return lbl
    }()
    
    let signUpBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Sign Up", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(gotoSignUpVC), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //Root view
        view.addSubview(formViewHolder)
        view.addSubview(footerView)
        
        //Constaint
        setUpformViewHolder()
        setUpFooterHolder()
        
        
    }
    
    func setUpformViewHolder(){
        formViewHolder.translatesAutoresizingMaskIntoConstraints = false
        formViewHolder.widthAnchor.constraint(equalToConstant: 300).isActive = true
        formViewHolder.heightAnchor.constraint(equalToConstant: 400).isActive = true
        formViewHolder.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        formViewHolder.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        formViewHolder.addSubview(titleLabel)
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.topAnchor.constraint(equalTo: formViewHolder.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: formViewHolder.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: formViewHolder.trailingAnchor).isActive = true
        
        formViewHolder.addSubview(subTitleLabel)
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: formViewHolder.leadingAnchor).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: formViewHolder.trailingAnchor).isActive = true
        
        formViewHolder.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 24).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: formViewHolder.leadingAnchor).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: formViewHolder.trailingAnchor).isActive = true
        
        formViewHolder.addSubview(userNameTextField)
        userNameTextField.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        userNameTextField.leadingAnchor.constraint(equalTo: formViewHolder.leadingAnchor).isActive = true
        userNameTextField.trailingAnchor.constraint(equalTo: formViewHolder.trailingAnchor).isActive = true
        
        formViewHolder.addSubview(userPasswordLabel)
        userPasswordLabel.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 24).isActive = true
        userPasswordLabel.leadingAnchor.constraint(equalTo: formViewHolder.leadingAnchor).isActive = true
        userPasswordLabel.trailingAnchor.constraint(equalTo: formViewHolder.trailingAnchor).isActive = true
        
        formViewHolder.addSubview(userPasswordTextField)
        userPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        userPasswordTextField.topAnchor.constraint(equalTo: userPasswordLabel.bottomAnchor, constant: 8).isActive = true
        userPasswordTextField.leadingAnchor.constraint(equalTo: formViewHolder.leadingAnchor).isActive = true
        userPasswordTextField.trailingAnchor.constraint(equalTo: formViewHolder.trailingAnchor).isActive = true
        
        formViewHolder.addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: userPasswordTextField.bottomAnchor, constant: 24).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: formViewHolder.leadingAnchor).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: formViewHolder.trailingAnchor).isActive = true
        loginButton.addTarget(self, action: #selector(submitLogin(_:)), for: .touchUpInside)
    }
    
    func setUpFooterHolder(){
        footerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        footerView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        footerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        footerView.addSubview(horizontalStackView)
        horizontalStackView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        horizontalStackView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        horizontalStackView.addArrangedSubview(dontHaveAccLabel)
        horizontalStackView.addArrangedSubview(signUpBtn)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func gotoSignUpVC() {
        let signUpViewController = SignUpViewController()
        self.present(signUpViewController, animated: true, completion: nil)
    }
    
    @objc func onEditingChanged(_ textField: UITextField){
        if textField.tag == 1 {
            userNameString = textField.text
        } else if textField.tag == 2 {
            userPasswordString = textField.text
        }
    }
    
    @objc func submitLogin(_ sender: UIButton){
        let regex = try! NSRegularExpression(pattern: "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        let a = regex.matches(userPasswordString ?? "")
        print("\(a)")
        
    }
    
    func isValidEmail(emailString: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let checkMail = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return checkMail.evaluate(with: emailString)
        
    }
    
    func isValidPassword(pwdString: String) -> Bool {
        //        let pwdRegEx = "[A-Z0-9a-z!@#$%^&*()]"
        
        return false
    }
    
    func testRegEx(_ text:String) -> Bool {
        let regExPattern = "[0-9]"
        let mChecker = NSPredicate(format: "SELF MATCHES %@", regExPattern)
        return mChecker.evaluate(with: text)
    }
    
    func checkRegEx(text:String) -> Bool {
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[a-z]at")
        return regex.firstMatch(in: text, options: [], range: range) != nil
    }
    
    
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
