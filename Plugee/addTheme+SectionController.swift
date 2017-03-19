//
//  addThemeController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 16/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit



class addThemeController: UIViewController {
    
    /*--------------------------------------- VARIABLES ---------------------------------------------*/

    var delegate:AddingSectionThemeDelegate!
    
    
    let labelNew = myLabel(myText : "Nouveau")
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        tf.placeholder = "Veuillez remplir"
        return tf
    }()
    
    let bottomLineTextField : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 75, b: 214, g: 199)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let buttonValidate : UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CRÉER", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(r: 75, b: 214, g: 199)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        self.view.backgroundColor = UIColor(r: 227, b: 228, g: 231)
        self.title = "Ajouter"
        self.view.addSubview(labelNew)
        self.view.addSubview(textField)
        self.view.addSubview(bottomLineTextField)
        self.view.addSubview(buttonValidate)
        hideKeyboardWhenTappedAround()
        setupLabelNew()
        setupTextField()
        setupBottomLineTextField()
        setupButtonValidate()
    }
    
    func handleCreate() {
        if let text = textField.text {
            if !(text.isEmpty) {
                delegate.sendString(text: text)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setupButtonValidate() {
        buttonValidate.topAnchor.constraint(equalTo: bottomLineTextField.bottomAnchor, constant: 60).isActive = true
        buttonValidate.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonValidate.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        buttonValidate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonValidate.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
    }
    
    func setupBottomLineTextField() {
        bottomLineTextField.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 0).isActive = true
        bottomLineTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bottomLineTextField.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        bottomLineTextField.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    func setupTextField() {
        textField.topAnchor.constraint(equalTo: labelNew.topAnchor, constant: 120).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        textField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupLabelNew(){
        labelNew.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        labelNew.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        labelNew.widthAnchor.constraint(equalToConstant: 100).isActive = true
        labelNew.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
