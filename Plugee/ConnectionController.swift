//
//  ViewController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 05/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ConnectionController : UIViewController {
    
    let EMAIL = "test"
    let PASSWORD = "test"
    let shiftOfTextFiels : CGFloat = 30
    
    var isOnConnectionScreen = true
    
    var copyrightLabel = CopyrightWathisLabel()
    
    var labelOnTop = LabelTitleConnectionScreen(text : "Plugee")
    var usernameTextField = TextFieldLoginRegister(placeholderText: "Email", isSecureEntry: false)
    var emailTextField = TextFieldLoginRegister(placeholderText: "Mot de passe",isSecureEntry : false)
    var passwordTextField = TextFieldLoginRegister(placeholderText: "Vérification",isSecureEntry : true)
    let loginButton = ButtonLoginRegister(text: "CONNEXION", backgroundColor: UIColor(r: 75, g: 214, b: 199),textColor: .white)
    let registerButton = ButtonLoginRegister(text: "INSCRIPTION",backgroundColor: .white, textColor: .gray)
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        hideKeyboardWhenTappedAround()
        setupViews()
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    /*------------------------------------ FUNCTIONS HANDLE ---------------------------------------------*/
    
    func handleLogin() {
        if (isOnConnectionScreen){
            if (emailTextField.text == EMAIL && passwordTextField.text == PASSWORD){
                dismiss(animated: true, completion: nil)
            }
        } else {
            isOnConnectionScreen = true
            usernameTextField.isUserInteractionEnabled = false
            usernameTextField.isHidden = true
            
            constraintOfEmailTextField?.isActive = false
            constraintOfEmailTextField = emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -2*shiftOfTextFiels)
            constraintOfEmailTextField?.isActive = true
            
            constraintOfPasswordTextField?.isActive = false
            constraintOfPasswordTextField = passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 0)
            constraintOfPasswordTextField?.isActive = true
            
        }
    }
    
    func handleRegister() {
        if !(isOnConnectionScreen) && (usernameTextField.text != nil && passwordTextField.text != nil && emailTextField.text != nil){
            present(EnterNameController(), animated: true, completion: nil)
        }else {
            isOnConnectionScreen = false
            usernameTextField.isUserInteractionEnabled = true
            usernameTextField.isHidden = false
            
            constraintOfUsernameTextField?.isActive = false
            constraintOfUsernameTextField = usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : CGFloat(-3.5*shiftOfTextFiels))
            constraintOfUsernameTextField?.isActive = true
            
            constraintOfEmailTextField?.isActive = false
            constraintOfEmailTextField = emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -1.5*shiftOfTextFiels)
            constraintOfEmailTextField?.isActive = true
            
            constraintOfPasswordTextField?.isActive = false
            constraintOfPasswordTextField = passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 1/2*shiftOfTextFiels)
            constraintOfPasswordTextField?.isActive = true
        }
    }
    
    /*------------------------------------ CONSTRAINTS ---------------------------------------------*/
    
    var constraintOfEmailTextField : NSLayoutConstraint?
    var constraintOfPasswordTextField : NSLayoutConstraint?
    var constraintOfUsernameTextField : NSLayoutConstraint?
    
    func setupViews() {
        self.view.addSubview(labelOnTop)
        
        labelOnTop.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelOnTop.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        labelOnTop.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        labelOnTop.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(usernameTextField)
        
        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        constraintOfUsernameTextField = usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : CGFloat(-2*shiftOfTextFiels))
        constraintOfUsernameTextField?.isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 8/10).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        usernameTextField.isHidden = true
        usernameTextField.isUserInteractionEnabled = false
        
        self.view.addSubview(emailTextField)
        
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        constraintOfEmailTextField = emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -2*shiftOfTextFiels)
        constraintOfEmailTextField?.isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 8/10).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(passwordTextField)
        
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        constraintOfPasswordTextField = passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 0)
        constraintOfPasswordTextField?.isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 8/10).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(copyrightLabel)
        
        copyrightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        copyrightLabel.topAnchor.constraint(equalTo: view.bottomAnchor,constant : -30).isActive = true
        copyrightLabel.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor).isActive = true
        copyrightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(registerButton)
        
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: copyrightLabel.topAnchor,constant : -30).isActive = true
        registerButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(loginButton)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor,constant : -10).isActive = true
        loginButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}
