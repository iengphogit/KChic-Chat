//
//  SignUpViewController.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/9/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit
import Firebase

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
    
    let bodyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let signUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mLogo: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "logo-ios")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome to"
        lbl.textColor = UIColor.gray
        lbl.font = UIFont(name: lbl.font.fontName, size: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Montserrat-Black", size: 22)
        let myStringTitle = "KChicChat"
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: myStringTitle)
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(netHex: 0x53BAB6), range: NSRange(location: 5, length: 4))
        lbl.attributedText = attributeString
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email & Phone"
        tf.tag = 1
        tf.addTarget(self, action: #selector(onEditChanged(_:)), for: UIControl.Event.editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let userNameSeparator:UILabel = {
        let line = UILabel()
        line.backgroundColor = UIColor.gray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    var userNameLabelMessage:UILabel = {
        let msg = UILabel()
        msg.textColor = .red
        msg.text = "N/A"
        msg.isHidden = true
        msg.numberOfLines = 1
        msg.font = UIFont(name: msg.font.fontName, size: 12)
        msg.translatesAutoresizingMaskIntoConstraints = false
        return msg
    }()
    
    let userPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.tag = 2
        tf.addTarget(self, action: #selector(onEditChanged(_:)), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let userPasswordSeparator: UILabel = {
        let line = UILabel()
        line.backgroundColor = .gray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    var userNamePasswordLabelMessage: UILabel = {
        let msg = UILabel()
        msg.textColor = .red
        msg.text = "N/A"
        msg.isHidden = true
        msg.numberOfLines = 1
        msg.font = UIFont(name: msg.font.fontName, size: 12)
        msg.translatesAutoresizingMaskIntoConstraints = false
        return msg
    }()
    
    let userConfirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirm"
        tf.isSecureTextEntry = true
        tf.tag = 3
        tf.addTarget(self, action: #selector(onEditChanged(_:)), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let userConfirmPasswordSeparator: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let userNameConfirmLabelMessage: UILabel = {
        let msg = UILabel()
        msg.text = "N/A"
        msg.textColor = .red
        msg.isHidden = true
        msg.numberOfLines = 1
        msg.font = UIFont(name: msg.font.fontName, size: 12)
        msg.translatesAutoresizingMaskIntoConstraints = false
        return msg
    }()
    
    let registerBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("REGISTER", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.init(netHex: 0x53bab6), for: UIControl.State.normal)
        btn.layer.borderColor = UIColor.init(netHex: 0x53bab6).cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 6
        btn.addTarget(self, action: #selector(submitRegister(_:)), for: UIControl.Event.touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let haveAnAccountLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Already have an account?"
        lbl.textColor = .gray
        return lbl
    }()
    
    let signInButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Sign In", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(gotoSignIn), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    let googleButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Login with Google+", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.red, for: UIControl.State.normal)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let facebookButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Login with Facebook", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var spinnerIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(navBar)
        view.addSubview(bodyView)
        
        //set constraints
        setupBodyView()
    }
    
    func setupBodyView(){
        bodyView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        bodyView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bodyView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bodyView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        bodyView.addSubview(signUpView)
        signUpView.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 100).isActive = true
        signUpView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 28).isActive = true
        signUpView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -28).isActive = true
        signUpView.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 8).isActive = true
        signUpView.centerXAnchor.constraint(equalTo: bodyView.centerXAnchor).isActive = true
        
        signUpView.addSubview(mLogo)
        mLogo.topAnchor.constraint(equalTo: signUpView.topAnchor, constant: 32).isActive = true
        mLogo.widthAnchor.constraint(equalToConstant: 64).isActive = true
        mLogo.heightAnchor.constraint(equalToConstant: 64).isActive = true
        mLogo.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 8).isActive = true
        
        signUpView.addSubview(welcomeLabel)
        welcomeLabel.topAnchor.constraint(equalTo: mLogo.topAnchor, constant: 8).isActive = true
        welcomeLabel.leadingAnchor.constraint(equalTo: mLogo.trailingAnchor, constant: 8).isActive = true
        
        signUpView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 3).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: mLogo.trailingAnchor, constant: 8).isActive = true
        
        signUpView.addSubview(userNameTextField)
        userNameTextField.topAnchor.constraint(equalTo: mLogo.bottomAnchor, constant: 16).isActive = true
        userNameTextField.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 16).isActive = true
        userNameTextField.trailingAnchor.constraint(equalTo: signUpView.trailingAnchor, constant: -16).isActive = true
        
        signUpView.addSubview(userNameSeparator)
        userNameSeparator.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 8).isActive = true
        userNameSeparator.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 16).isActive = true
        userNameSeparator.trailingAnchor.constraint(equalTo: signUpView.trailingAnchor, constant: -16).isActive = true
        userNameSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        signUpView.addSubview(userNameLabelMessage)
        userNameLabelMessage.translatesAutoresizingMaskIntoConstraints = false
        userNameLabelMessage.topAnchor.constraint(equalTo: userNameSeparator.bottomAnchor, constant: 8).isActive = true
        userNameLabelMessage.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 16).isActive = true
        userNameLabelMessage.trailingAnchor.constraint(equalTo: signUpView.trailingAnchor, constant: -16).isActive = true
        
        signUpView.addSubview(userPasswordTextField)
        userPasswordTextField.topAnchor.constraint(equalTo: userNameLabelMessage.bottomAnchor, constant: 8).isActive = true
        userPasswordTextField.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 16).isActive = true
        userPasswordTextField.trailingAnchor.constraint(equalTo: signUpView.trailingAnchor, constant: -16).isActive = true
        
        signUpView.addSubview(userPasswordSeparator)
        userPasswordSeparator.topAnchor.constraint(equalTo: userPasswordTextField.bottomAnchor, constant: 8).isActive = true
        userPasswordSeparator.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 16).isActive = true
        userPasswordSeparator.trailingAnchor.constraint(equalTo: signUpView.trailingAnchor, constant: -16).isActive = true
        userPasswordSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        signUpView.addSubview(userNamePasswordLabelMessage)
        userNamePasswordLabelMessage.topAnchor.constraint(equalTo: userPasswordSeparator.bottomAnchor, constant: 8).isActive = true
        userNamePasswordLabelMessage.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 16).isActive = true
        userNamePasswordLabelMessage.trailingAnchor.constraint(equalTo: signUpView.trailingAnchor, constant: -16).isActive = true
        
        signUpView.addSubview(userConfirmPasswordTextField)
        userConfirmPasswordTextField.topAnchor.constraint(equalTo: userNamePasswordLabelMessage.bottomAnchor, constant: 8).isActive = true
        userConfirmPasswordTextField.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 16).isActive = true
        userConfirmPasswordTextField.trailingAnchor.constraint(equalTo: signUpView.trailingAnchor, constant: -16).isActive = true
        
        signUpView.addSubview(userConfirmPasswordSeparator)
        userConfirmPasswordSeparator.topAnchor.constraint(equalTo: userConfirmPasswordTextField.bottomAnchor, constant: 8).isActive = true
        userConfirmPasswordSeparator.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 16).isActive = true
        userConfirmPasswordSeparator.trailingAnchor.constraint(equalTo: signUpView.trailingAnchor, constant: -16).isActive = true
        userConfirmPasswordSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        signUpView.addSubview(userNameConfirmLabelMessage)
        userNameConfirmLabelMessage.topAnchor.constraint(equalTo: userConfirmPasswordSeparator.bottomAnchor, constant: 8).isActive = true
        userNameConfirmLabelMessage.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 16).isActive = true
        userNameConfirmLabelMessage.trailingAnchor.constraint(equalTo: signUpView.trailingAnchor, constant: -16).isActive = true

        signUpView.addSubview(registerBtn)
        registerBtn.topAnchor.constraint(equalTo: userNameConfirmLabelMessage.bottomAnchor, constant: 8).isActive = true
        registerBtn.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 8).isActive = true
        registerBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        registerBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        signUpView.addSubview(horizontalStackView)
        horizontalStackView.topAnchor.constraint(equalTo: registerBtn.bottomAnchor, constant: 16).isActive = true
        horizontalStackView.centerXAnchor.constraint(equalTo: signUpView.centerXAnchor, constant: 0).isActive = true
        
        horizontalStackView.addArrangedSubview(haveAnAccountLabel)
        horizontalStackView.addArrangedSubview(signInButton)
        
        
        bodyView.addSubview(googleButton)
        googleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        googleButton.centerXAnchor.constraint(equalTo: signUpView.centerXAnchor).isActive = true
        googleButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        googleButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bodyView.addSubview(facebookButton)
        facebookButton.bottomAnchor.constraint(equalTo: googleButton.topAnchor, constant: -20).isActive = true
        facebookButton.centerXAnchor.constraint(equalTo: signUpView.centerXAnchor).isActive = true
        facebookButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
    @objc func onEditChanged(_ textField: UITextField) {
        switch (textField.tag ) {
        case 1:
            self.userNamer = textField.text ?? ""
            if self.isAttemed {
                if self.checkUsername(textField.text ?? "") {
                    userNameLabelMessage.isHidden = true
                } else {
                    userNameLabelMessage.isHidden = false
                }
                
            }
        case 2:
            self.userPassword = textField.text ?? ""
            if self.isAttemed {
                if self.checkPassword(textField.text ?? "") {
                    userNamePasswordLabelMessage.isHidden = true
                    userNamePasswordLabelMessage.numberOfLines = 1
                } else {
                    userNamePasswordLabelMessage.isHidden = false
                    userNamePasswordLabelMessage.numberOfLines = 3
                }
            }
        case 3:
            self.userConfirmPassword = textField.text ?? ""
            if self.isAttemed {
                if (self.userPassword == self.userConfirmPassword) {
                 userNameConfirmLabelMessage.isHidden = true
                } else {
                 userNameConfirmLabelMessage.isHidden = false
                }
            }
            
        default:
            self.userNamer = ""
            self.userPassword = ""
            self.userConfirmPassword = ""
        }
    }
    
    let spinnerView = SpinnerViewController()
    func showSpinnerView(){
        spinnerView.view.frame = view.frame
        view.addSubview(spinnerView.view)
        spinnerView.didMove(toParent: self)
    }
    
    func hideSpinnerView(){
        spinnerView.willMove(toParent: nil)
        spinnerView.view.removeFromSuperview()
        spinnerView.removeFromParent()
    }
    
    @objc func submitRegister(_ button: UIButton){
        //print("Name: \(self.userNamer) Pass: \(self.userPassword) Confirm: \(self.userConfirmPassword)")
        
        self.isAttemed = true
        var isValid: Bool = false
        
        userNameLabelMessage.text = "Invalid email address. eg. example@mail.com"
        if checkUsername(self.userNamer) {
            userNameLabelMessage.isHidden = true
            isValid = true
        } else {
            userNameLabelMessage.isHidden = false
            isValid = false
        }
        
        userNamePasswordLabelMessage.text = "Invalid password. Your password must be at least 8 characters long, contain at least one number and have a mixture of uppercase and lowercase letters."
        if checkPassword(self.userPassword) && !self.userPassword.isEmpty {
            userNamePasswordLabelMessage.isHidden = true
            userNamePasswordLabelMessage.numberOfLines = 1
            isValid = true
        }else{
            userNamePasswordLabelMessage.isHidden = false
            userNamePasswordLabelMessage.contentMode = .scaleToFill
            userNamePasswordLabelMessage.numberOfLines = 3
            isValid = false
        }
        
        userNameConfirmLabelMessage.text = "Your password and confirmation password do not match."
        if self.userPassword == self.userConfirmPassword && !self.userConfirmPassword.isEmpty {
            userNameConfirmLabelMessage.isHidden = true
            isValid = true
        }else{
            userNameConfirmLabelMessage.isHidden = false
            isValid = false
        }
        
        if isValid {
            self.showSpinnerView()
            Auth.auth().createUser(withEmail: userNamer, password: userPassword) { (User, Error) in
                if Error != nil {
                    self.hideSpinnerView()
                 //Error
                    print(Error!)
                    
                }else{
                    //Successful
                    print("Insert successful")
                    self.hideSpinnerView()
                }
            }
        } 
        
    }
    
    @objc func gotoSignIn(_ sender: UIButton){
        let loginVC = LoginViewController()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func checkUsername(_ text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let checkMail = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return checkMail.evaluate(with: text)
    }
    
    func checkPassword(_ text: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return regex.matches(text)
    }
    
}
