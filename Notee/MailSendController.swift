//
//  MailSendController.swift
//  Notee
//
//  Created by Mathis Delaunay on 24/06/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation


class MailSendController: UIViewController {
    
    /*------------------------------------ VARIABLES ----------------------------------------------*/
    
    var copyrightLabel = CopyrightWathisLabel()
    var emailMessage = LabelTitleConnectionScreen(text: "Email envoyé",size: 40)
    
    /*------------------------------------ CONSTANTS ----------------------------------------------*/
    
    let continueButton = ButtonLoginRegister(text: "CONTINUER", backgroundColor: UIColor(r: 75, g: 214, b: 199),textColor: .white)
    
    /*------------------------------------ CONSTRUCTORS -------------------------------------------*/
    /*------------------------------------ VIEW DID SOMETHING -------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        setupViews()
    }
    
    /*------------------------------------ FUNCTIONS DELEGATE -------------------------------------*/
    /*------------------------------------ FUNCTIONS DATASOURCE -----------------------------------*/
    /*------------------------------------ BACK-END FUNCTIONS -------------------------------------*/
    /*------------------------------------ HANDLE FUNCTIONS ---------------------------------------*/
    
    func  handleContinue(){
        present(TabBarController(), animated: false, completion: nil)
    }
    
    /*------------------------------------ FRONT-END FUNCTIONS ------------------------------------*/
    
    func setText(text : String){
        emailMessage.text = text
    }
    
    /*------------------------------------ CONSTRAINTS --------------------------------------------*/
    
    func setupViews() {
        self.view.addSubview(copyrightLabel)
        
        copyrightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        copyrightLabel.topAnchor.constraint(equalTo: view.bottomAnchor,constant : -30).isActive = true
        copyrightLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        copyrightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(emailMessage)
        
        emailMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -70).isActive = true
        emailMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailMessage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        emailMessage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(continueButton)
        
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 100).isActive = true
        continueButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 8/10).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}
