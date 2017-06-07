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
    
    var labelOnTop = LabelTitleConnectionScreen(text : "Plugee",size: 80)
    var emailTextField = TextFieldLoginRegister(placeholderText: "Email", isSecureEntry: false)
    var passwordTextField = TextFieldLoginRegister(placeholderText: "Mot de passe",isSecureEntry : true)
    var passwordVerificationTextField = TextFieldLoginRegister(placeholderText: "Vérification",isSecureEntry : true)
    let firstButton = ButtonLoginRegister(text: "CONNEXION", backgroundColor: UIColor(r: 75, g: 214, b: 199),textColor: .white)
    let secondButton = ButtonLoginRegister(text: "INSCRIPTION",backgroundColor: .white, textColor: .gray)
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        hideKeyboardWhenTappedAround()
        setupViews()
        firstButton.addTarget(self, action: #selector(handleFirstButton), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(handleSecondButton), for: .touchUpInside)
    }
    
    /*------------------------------------ FUNCTIONS HANDLE ---------------------------------------------*/
    
    func handleFirstButton() {
        if (isOnConnectionScreen){
            //So the button is "CONNEXION"
            if (emailTextField.text == EMAIL && passwordTextField.text == PASSWORD){
                dismiss(animated: true, completion: nil)
            }
            
        } else {
            
            isOnConnectionScreen = true
            passwordVerificationTextField.isUserInteractionEnabled = false
            passwordVerificationTextField.isHidden = true
            
            constraintOfEmailTextField?.isActive = false
            constraintOfEmailTextField = emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -2*shiftOfTextFiels)
            constraintOfEmailTextField?.isActive = true
            
            constraintOfPasswordTextField?.isActive = false
            constraintOfPasswordTextField = passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 0)
            constraintOfPasswordTextField?.isActive = true
        }
    }
    
    func handleSecondButton() {
        if !(isOnConnectionScreen) && (emailTextField.text != nil && passwordVerificationTextField.text != nil && passwordTextField.text != nil){
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            present(EnterNameController(), animated: false, completion: nil)
        }else {
            
            isOnConnectionScreen = false
            passwordVerificationTextField.isUserInteractionEnabled = true
            passwordVerificationTextField.isHidden = false
            
            constraintOfEmailTextField?.isActive = false
            constraintOfEmailTextField = emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : CGFloat(-2.5*shiftOfTextFiels))
            constraintOfEmailTextField?.isActive = true
            
            constraintOfPasswordTextField?.isActive = false
            constraintOfPasswordTextField = passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -1/2*shiftOfTextFiels)
            constraintOfPasswordTextField?.isActive = true
            
            constraintOfPasswordVerificationTextField?.isActive = false
            constraintOfPasswordVerificationTextField = passwordVerificationTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 1.5*shiftOfTextFiels)
            constraintOfPasswordVerificationTextField?.isActive = true
        }
    }
    
    /*------------------------------------ CONSTRAINTS ---------------------------------------------*/
    
    var constraintOfPasswordTextField : NSLayoutConstraint?
    var constraintOfPasswordVerificationTextField : NSLayoutConstraint?
    var constraintOfEmailTextField : NSLayoutConstraint?
    
    func setupViews() {
        self.view.addSubview(labelOnTop)
        
        labelOnTop.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelOnTop.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        labelOnTop.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        labelOnTop.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
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
        
        self.view.addSubview(passwordVerificationTextField)
        
        passwordVerificationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        constraintOfPasswordVerificationTextField = passwordVerificationTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 0)
        constraintOfPasswordVerificationTextField?.isActive = true
        passwordVerificationTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 8/10).isActive = true
        passwordVerificationTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordVerificationTextField.isHidden = true
        passwordVerificationTextField.isUserInteractionEnabled = false
        
        self.view.addSubview(copyrightLabel)
        
        copyrightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        copyrightLabel.topAnchor.constraint(equalTo: view.bottomAnchor,constant : -30).isActive = true
        copyrightLabel.widthAnchor.constraint(equalTo: passwordVerificationTextField.widthAnchor).isActive = true
        copyrightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(secondButton)
        
        secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        secondButton.bottomAnchor.constraint(equalTo: copyrightLabel.topAnchor,constant : -30).isActive = true
        secondButton.widthAnchor.constraint(equalTo: passwordVerificationTextField.widthAnchor).isActive = true
        secondButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(firstButton)
        
        firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstButton.bottomAnchor.constraint(equalTo: secondButton.topAnchor,constant : -10).isActive = true
        firstButton.widthAnchor.constraint(equalTo: passwordVerificationTextField.widthAnchor).isActive = true
        firstButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}
