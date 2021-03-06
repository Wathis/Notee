//
//  EnterNameController.swift
//  Notee
//
//  Created by Mathis Delaunay on 09/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Firebase
import UIKit
import UITextField_Shake

class EnterNameController: UIViewController, UITextFieldDelegate {
    
    /*------------------------------------ VARIABLES ----------------------------------------------*/
    
    var copyrightLabel = CopyrightWathisLabel()
    var member : Member?
    var labelOnTop = LabelTitleConnectionScreen(text: "Notee",size: 70)

    
    /*------------------------------------ CONSTANTS ----------------------------------------------*/
    
    let nameTextField = TextFieldLoginRegister(placeholderText: "@Username", isSecureEntry: false)
    let continueButton = ButtonLoginRegister(text: "CONTINUER", backgroundColor: UIColor(r: 75, g: 214, b: 199),textColor: .white)
    let connectionButton = ButtonLoginRegister(text: "CONNEXION",backgroundColor: .white, textColor: .gray)
    
    /*------------------------------------ CONSTRUCTORS -------------------------------------------*/
    /*------------------------------------ VIEW DID SOMETHING -------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        hideKeyboardWhenTappedAround()
        nameTextField.textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        connectionButton.addTarget(self, action: #selector(handleConnection), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        setupViews()
    }
    

    /*------------------------------------ FUNCTIONS DELEGATE -------------------------------------*/
    /*------------------------------------ FUNCTIONS DATASOURCE -----------------------------------*/
    /*------------------------------------ BACK-END FUNCTIONS -------------------------------------*/
    
    func updatePseudo(forUID: String, pseudo : String) {
        let values = ["pseudo" : pseudo] as [String : Any]
        let refData = Database.database().reference().child("members").child(forUID)
        refData.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            self.goToWelcomeScreen()
        }
    }
    
    /*------------------------------------ HANDLE FUNCTIONS ---------------------------------------*/
    
    func handleContinue() {
        guard let uid = member?.id, let pseudo = nameTextField.text else {
            return
        }
        if (pseudo != "@" && pseudo != "" && pseudo.characters.count < 14){
            updatePseudo(forUID: uid,pseudo : pseudo)
        } else {
            if pseudo.characters.count >= 14 {
                self.present(PlugAlertModalView(title: "Oups !", description: "Votre pseudo doit faire moins de 14 caractères"), animated: false, completion: nil)
            }
            self.nameTextField.text = ""
            nameTextField.textField.shake()
        }
    }
    
    /*------------------------------------ FRONT-END FUNCTIONS ------------------------------------*/
    
    func goToWelcomeScreen() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        present(WelcomeScreenController(), animated: false, completion: nil)
    }
    
    func handleConnection() {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidChanged() {
        if (nameTextField.text?.characters.count == 1 && nameTextField.text != "@"){
            nameTextField.textField.text = "@" + nameTextField.text!
        }
        if (nameTextField.textField.text == "@"){
            nameTextField.textField.text = ""
        }
        if nameTextField.textField.text?.characters.first != "@" {
            nameTextField.textField.text = "@" + nameTextField.textField.text!
        }
    }

    
    /*------------------------------------ CONSTRAINTS --------------------------------------------*/
    
    func setupViews() {
        self.view.addSubview(copyrightLabel)
        
        copyrightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        copyrightLabel.topAnchor.constraint(equalTo: view.bottomAnchor,constant : -30).isActive = true
        copyrightLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        copyrightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(connectionButton)
        
        connectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectionButton.bottomAnchor.constraint(equalTo: copyrightLabel.topAnchor,constant : -30).isActive = true
        connectionButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 8/10).isActive = true
        connectionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(continueButton)
        
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: connectionButton.topAnchor,constant : -10).isActive = true
        continueButton.widthAnchor.constraint(equalTo: connectionButton.widthAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(nameTextField)
        
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 8/10).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(labelOnTop)
        
        labelOnTop.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        labelOnTop.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelOnTop.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        labelOnTop.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
}
