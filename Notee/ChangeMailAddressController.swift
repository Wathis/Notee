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

class ChangeMailAddressController : UIViewController {
    
    var memberConnected : Member?
    var delegate : ChangeMailDelegate?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.title = "Modification e-mail"
        self.view.addSubview(textField)
        self.view.addSubview(bottomLineTextField)
        self.view.addSubview(buttonSubmit)
        hideKeyboardWhenTappedAround()
        setupTextField()
        setupBottomLineTextField()
        setupButtonValidate()
    }
    
    var credential : AuthCredential!
    var connectionController : AlertTextFieldModalView!
    
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
                self.handleSubmit()
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            } else {
                user?.updateEmail(to: email) { (error) in
                    if (error != nil){
                        print(error!)
                        return
                    }
                    let confirmationAlert = PlugAlertModalView(title: "Félicitation", description: "Votre changement d'adresse à bien été pris en compte")
                    self.present(confirmationAlert, animated: false, completion: nil)
                    self.memberConnected?.email = email
                    self.delegate?.receiveMailChanged(email: email)
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    Database.database().reference().child("members/\(uid)/email").setValue(email)
                }
            }
        })
    }
    
    func handleSubmit() {
        connectionController = AlertTextFieldModalView(title: "Mot de passe", secureEntry: true)
        connectionController.buttonConfirmation.addTarget(self, action: #selector(enterPassword), for: .touchUpInside)
        present(connectionController, animated: false, completion: nil)
    }
    
    func setupButtonValidate() {
        buttonSubmit.topAnchor.constraint(equalTo: bottomLineTextField.bottomAnchor, constant: 60).isActive = true
        buttonSubmit.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonSubmit.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        buttonSubmit.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonSubmit.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
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
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
