//
//  ViewController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 05/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ConnectionController : UIViewController {
    
    var labelOnTop : UILabel = {
        var label = UILabel()
        label.text = "Plugee"
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 80)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var emailTextField : UITextField = {
        var tf = UITextField()
        tf.font = UIFont(name: "Helvetica-Light",size: 20)
        tf.textColor = .white
        if let fontName = UIFont(name: "Helvetica-Light",size: 20) {
            tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), NSFontAttributeName : fontName])
        } else {
            tf.placeholder = "Email"
        }
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var passwordTextField : UITextField = {
        var tf = UITextField()
        tf.font = UIFont(name: "Helvetica-Light",size: 20)
        tf.textColor = .white
        tf.isSecureTextEntry = true
        if let fontName = UIFont(name: "Helvetica-Light",size: 20) {
            tf.attributedPlaceholder = NSAttributedString(string: "Mot de passe", attributes: [NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), NSFontAttributeName : fontName])
        } else {
            tf.placeholder = "Mot de passe"
        }
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let separatorLineForEmail : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorLineForPassword : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginButton = buttonLoginRegister(text: "CONNECTION", backgroundColor: UIColor(r: 75, g: 214, b: 199),textColor: .white)
    let registerButton = buttonLoginRegister(text: "INSCRIPTION",backgroundColor: .white, textColor: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        hideKeyboardWhenTappedAround()
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(labelOnTop)
        
        labelOnTop.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelOnTop.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        labelOnTop.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        labelOnTop.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(emailTextField)
        
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -40).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 8/10).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(separatorLineForEmail)
        
        separatorLineForEmail.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor).isActive = true
        separatorLineForEmail.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        separatorLineForEmail.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        separatorLineForEmail.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(passwordTextField)
        
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 40).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 8/10).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(separatorLineForPassword)
        
        separatorLineForPassword.centerXAnchor.constraint(equalTo: passwordTextField.centerXAnchor).isActive = true
        separatorLineForPassword.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        separatorLineForPassword.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor).isActive = true
        separatorLineForPassword.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(loginButton)
        
        loginButton.centerXAnchor.constraint(equalTo: separatorLineForPassword.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: separatorLineForPassword.bottomAnchor,constant : 50).isActive = true
        loginButton.widthAnchor.constraint(equalTo: separatorLineForPassword.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(registerButton)
        
        registerButton.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor,constant : 10).isActive = true
        registerButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }

}
