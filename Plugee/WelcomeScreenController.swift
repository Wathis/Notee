//
//  WelcomeScreenController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 10/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class WelcomeScreenController: UIViewController {

    var copyrightLabel = CopyrightWathisLabel()
    
    var welcomeLabel = LabelTitleConnectionScreen(text: "Bienvenue",size: 65)
    
    let continueButton = ButtonLoginRegister(text: "CONTINUER", backgroundColor: UIColor(r: 75, g: 214, b: 199),textColor: .white)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        setupViews()
    }
    
    func  handleContinue(){
        present(TabBarController(), animated: true, completion: nil)
    }
    
    func setupViews() {
        self.view.addSubview(copyrightLabel)
        
        copyrightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        copyrightLabel.topAnchor.constraint(equalTo: view.bottomAnchor,constant : -30).isActive = true
        copyrightLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        copyrightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.view.addSubview(welcomeLabel)
        
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -30).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(continueButton)
        
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 90).isActive = true
        continueButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 8/10).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}
