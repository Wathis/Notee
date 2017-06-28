//
//  ViewController.swift
//  Notee
//
//  Created by Mathis Delaunay on 05/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase
import UITextField_Shake
import AudioToolbox

class ConnectionController : UIViewController, UITextFieldDelegate {

    let shiftOfTextFiels : CGFloat = 30
    
    var isOnConnectionScreen = true
    
    var copyrightLabel = CopyrightWathisLabel()
    
    var delegate : LogoutUserDelegate?
    
    var labelOnTop = LabelTitleConnectionScreen(text : "Notee",size: 80)
    var emailTextField = TextFieldLoginRegister(placeholderText: "Email", isSecureEntry: false)
    var passwordTextField = TextFieldLoginRegister(placeholderText: "Mot de passe",isSecureEntry : true)
    var passwordVerificationTextField = TextFieldLoginRegister(placeholderText: "Vérification",isSecureEntry : true)
    let firstButton = ButtonLoginRegister(text: "CONNEXION", backgroundColor: UIColor(r: 75, g: 214, b: 199),textColor: .white)
    let secondButton = ButtonLoginRegister(text: "INSCRIPTION",backgroundColor: .white, textColor: .gray)
    let forgottenPasswordLabel = ForgottenPasswordLabel()
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        hideKeyboardWhenTappedAround()
        setupViews()
        passwordTextField.textField.delegate = self
        passwordVerificationTextField.textField.delegate = self
        emailTextField.textField.delegate = self
        forgottenPasswordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgottenPassword)))
        firstButton.addTarget(self, action: #selector(handleFirstButton), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(handleSecondButton), for: .touchUpInside)
    }
    
    /*------------------------------------ FUNCTIONS HANDLE ---------------------------------------------*/
    
    func forgottenPassword() {
        present(ForgottenPasswordController(), animated: true, completion: nil)
    }
    
    func handleFirstButton() {
        guard let email = emailTextField.text , let password = passwordTextField.text else {
            return
        }
        var errorDescription = ""
        if (isOnConnectionScreen){
            //So the button is "CONNEXION"
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print(error!)
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        
                        switch errCode {
                        case .emailAlreadyInUse :
                            errorDescription += "Email déjà utilisé"
                        case .wrongPassword :
                            self.passwordTextField.textField.shake()
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                        default:
                            print("")
                        }    
                    }
                    
                    return
                }
                self.delegate?.refreshPage()
                self.dismiss(animated: true, completion: nil)
            })
            
        } else if (emailTextField.text != nil && passwordVerificationTextField.text != nil && passwordTextField.text != nil)  {
            
            let values = ["email" : email, "pseudo" : "Undefined"]
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                guard let uid = user?.uid else {
                    return
                }
                
                let storageRef = Database.database().reference().child("members").child(uid)
                storageRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    self.selectUsername(member: Member(id : uid, email: email))
                })
            })
        }
    }
    
    func selectUsername(member : Member) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        let controller = EnterNameController()
        controller.member = member
        present(controller, animated: false, completion: nil)
    }
    
    func handleSecondButton() {
        
        if !(isOnConnectionScreen){
            isOnConnectionScreen = true
            changeTextInButtons()
            passwordVerificationTextField.isUserInteractionEnabled = false
            passwordVerificationTextField.isHidden = true
            forgottenPasswordLabel.isHidden = false
            
            constraintOfEmailTextField?.isActive = false
            constraintOfEmailTextField = emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -2*shiftOfTextFiels)
            constraintOfEmailTextField?.isActive = true
            
            constraintOfPasswordTextField?.isActive = false
            constraintOfPasswordTextField = passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 0)
            constraintOfPasswordTextField?.isActive = true
        }else {
            isOnConnectionScreen = false
            changeTextInButtons()
            forgottenPasswordLabel.isHidden = true
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
    
    func changeTextInButtons() {
        if (isOnConnectionScreen){
            firstButton.setTitle("CONNEXION", for: .normal)
            secondButton.setTitle("INSCRIPTION", for: .normal)
        } else {
            firstButton.setTitle("INSCRPTION", for: .normal)
            secondButton.setTitle("CONNEXION", for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleFirstButton()
        return true
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
        
        self.view.addSubview(forgottenPasswordLabel)
        
        forgottenPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgottenPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant : 0).isActive = true
        forgottenPasswordLabel.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor).isActive = true
        forgottenPasswordLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}
