//
//  WelcomeScreenController.swift
//  Notee
//
//  Created by Mathis Delaunay on 10/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class WelcomeScreenController: UIViewController {
    
    /*------------------------------------ VARIABLES ----------------------------------------------*/
    
    var copyrightLabel = CopyrightWathisLabel()
    var welcomeLabel = LabelTitleConnectionScreen(text: "Bienvenue",size: 65)
    
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
        if Auth.auth().currentUser?.uid != nil {
            present(TutorialController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil),animated: true,completion: nil)
        } else {
            present(ConnectionController(), animated: true, completion: nil)
        }
    }
    
    /*------------------------------------ FRONT-END FUNCTIONS ------------------------------------*/
    /*------------------------------------ CONSTRAINTS --------------------------------------------*/
    
    func setupViews() {
        self.view.addSubview(copyrightLabel)
        
        copyrightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        copyrightLabel.topAnchor.constraint(equalTo: view.bottomAnchor,constant : -30).isActive = true
        copyrightLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        copyrightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.view.addSubview(welcomeLabel)
        
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -70).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(continueButton)
        
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 100).isActive = true
        continueButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 8/10).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}
