//
//  ChangeMailAddressController.swift
//  Notee
//
//  Created by Mathis Delaunay on 08/08/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation



enum TypeModifyData {
    case email
    case pseudo
}

class ChangeUserDataController : UIViewController {
    
    
    /*------------------------------------ VARIABLES ----------------------------------------------*/
    
    var memberConnected : Member?
    var delegate : ChangeUserDataDelegate?
    var titleNav : String?
    var placeholder : String?
    var type : TypeModifyData?
    var credential : AuthCredential!
    var connectionController : AlertTextFieldModalView!
    
    /*------------------------------------ CONSTANTS ----------------------------------------------*/
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        tf.placeholder = "exemple@notee.fr"
        return tf
    }()
    let bottomLineTextField : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let buttonSubmit = ButtonInMenus(text: "CHANGER", backgroundColor: UIColor(r: 152, g: 152, b: 152))
    
    /*------------------------------------ CONSTRUCTORS -------------------------------------------*/
    
    init(title : String, placeholder : String, type : TypeModifyData ) {
        super.init(nibName: nil, bundle: nil)
        self.titleNav = title
        self.placeholder = placeholder
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*------------------------------------ VIEW DID SOMETHING -------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.title = titleNav
        self.view.addSubview(textField)
        self.view.addSubview(bottomLineTextField)
        self.view.addSubview(buttonSubmit)
        guard let typeValue = type else {return}
        switch typeValue {
        case .email:
            buttonSubmit.addTarget(self, action: #selector(handleSubmitEmail), for: .touchUpInside)
            break
        case .pseudo:
            buttonSubmit.addTarget(self, action: #selector(handleSubmitPseudo), for: .touchUpInside)
            break
        }
        self.textField.placeholder = placeholder
        hideKeyboardWhenTappedAround()
        setupTextField()
        setupBottomLineTextField()
        setupButtonValidate()
    }
    
    /*------------------------------------ FUNCTIONS DELEGATE -------------------------------------*/
    /*------------------------------------ FUNCTIONS DATASOURCE -----------------------------------*/
    /*------------------------------------ BACK-END FUNCTIONS -------------------------------------*/
    
    func enterPassword() {
        guard let email = self.memberConnected?.email, let password = connectionController.textField.text else {return}
        connectionController.handleCancel()
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        self.credential = credential
        tryChangeEmail()
    }
    
    func tryChangeEmail() {
        guard let email = self.textField.text, let uid = Auth.auth().currentUser?.uid else {return}
        let user = Auth.auth().currentUser
        user?.reauthenticate(with: credential, completion: { (error) in
            if error != nil {
                print(error!)
                self.handleSubmitEmail()
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            } else {
                user?.updateEmail(to: email) { (error) in
                    if (error != nil){
                        print(error!)
                        return
                    }
                    let confirmationAlert = PlugAlertModalView(title: "Félicitations", description: "Votre changement d'adresse a bien été pris en compte")
                    self.present(confirmationAlert, animated: false, completion: nil)
                    self.memberConnected?.email = email
                    self.delegate?.receiveMailChanged(email: email)
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    Database.database().reference().child("members/\(uid)/email").setValue(email)
                }
            }
        })
    }
    
    /*------------------------------------ HANDLE FUNCTIONS ---------------------------------------*/
    
    func handleSubmitPseudo() {
        guard let uid = Auth.auth().currentUser?.uid, var pseudo = self.textField.text else {return}
        if pseudo.characters.count > 0 && pseudo.characters.count < 14 {
            pseudo = "@" + pseudo
            self.memberConnected?.pseudo = pseudo
            self.delegate?.receivePseudoChanded(pseudo: pseudo)
            let confirmationAlert = PlugAlertModalView(title: "Félicitations", description: "Votre changement de pseudo a bien été pris en compte")
            self.present(confirmationAlert, animated: false, completion: nil)
            Database.database().reference().child("members/\(uid)/pseudo").setValue(pseudo)
        } else {
            if pseudo.characters.count > 14 {
                self.present(PlugAlertModalView(title: "Oups !", description: "Votre pseudo doit faire moins de 14 caractères"), animated: false, completion: nil)
            }
            self.textField.shake()
        }
    }
    func handleSubmitEmail() {
        connectionController = AlertTextFieldModalView(title: "Mot de passe", secureEntry: true)
        connectionController.buttonConfirmation.addTarget(self, action: #selector(enterPassword), for: .touchUpInside)
        present(connectionController, animated: false, completion: nil)
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    /*------------------------------------ FRONT-END FUNCTIONS ------------------------------------*/
    /*------------------------------------ CONSTRAINTS --------------------------------------------*/
    
    
    
   
    func setupButtonValidate() {
        buttonSubmit.topAnchor.constraint(equalTo: bottomLineTextField.bottomAnchor, constant: 60).isActive = true
        buttonSubmit.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonSubmit.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        buttonSubmit.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupBottomLineTextField() {
        bottomLineTextField.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 0).isActive = true
        bottomLineTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bottomLineTextField.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        bottomLineTextField.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    func setupTextField() {
        textField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        textField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
