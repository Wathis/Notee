//
//  ForgottenPasswordController.swift
//  Notee
//
//  Created by Mathis Delaunay on 24/06/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

import Firebase
import UIKit


class ForgottenPasswordController : UIViewController, UITextFieldDelegate {
    
    /*------------------------------------ VARIABLES ----------------------------------------------*/

    var member : Member?
    
    /*------------------------------------ CONSTANTS ----------------------------------------------*/
    
    let mailAddressTextField = TextFieldLoginRegister(placeholderText: "Adresse mail de récuperation", isSecureEntry: false)
    let continueButton = ButtonLoginRegister(text: "CONTINUER", backgroundColor: UIColor(r: 75, g: 214, b: 199),textColor: .white)
    let cancelButton = ButtonLoginRegister(text: "ANNULER",backgroundColor: .white, textColor: .gray)
    let labelOnTop = LabelTitleConnectionScreen(text: "Notee",size: 70)
    let copyrightLabel = CopyrightWathisLabel()
    
    /*------------------------------------ CONSTRUCTORS -------------------------------------------*/
    /*------------------------------------ VIEW DID SOMETHING -------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        hideKeyboardWhenTappedAround()
        cancelButton.addTarget(self, action: #selector(handleAnnuler), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        setupViews()
    }
    
    /*------------------------------------ FUNCTIONS DELEGATE -------------------------------------*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleContinue()
        return true
    }
    
    /*------------------------------------ FUNCTIONS DATASOURCE -----------------------------------*/
    /*------------------------------------ BACK-END FUNCTIONS -------------------------------------*/
    /*------------------------------------ HANDLE FUNCTIONS ---------------------------------------*/
    
    func handleContinue() {
        let controller = MailSendController()
        guard let email = mailAddressTextField.text else {
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                print(error!)
                controller.setText(text: "Email inconnu")
            } else {
                controller.setText(text: "Email envoyé")
            }
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func handleAnnuler() {
        dismiss(animated: true, completion: nil)
    }
    
    /*------------------------------------ FRONT-END FUNCTIONS ------------------------------------*/
    /*------------------------------------ CONSTRAINTS --------------------------------------------*/
    
    func setupViews() {
        self.view.addSubview(copyrightLabel)
        
        copyrightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        copyrightLabel.topAnchor.constraint(equalTo: view.bottomAnchor,constant : -30).isActive = true
        copyrightLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        copyrightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(cancelButton)
        
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: copyrightLabel.topAnchor,constant : -30).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 8/10).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(continueButton)
        
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor,constant : -10).isActive = true
        continueButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(mailAddressTextField)
        
        mailAddressTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mailAddressTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mailAddressTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 8/10).isActive = true
        mailAddressTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(labelOnTop)
        
        labelOnTop.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        labelOnTop.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelOnTop.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        labelOnTop.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
}
