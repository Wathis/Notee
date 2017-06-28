//
//  addThemeController.swift
//  Notee
//
//  Created by Mathis Delaunay on 27/06/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class addThemeController: UIViewController  {
    
    /*--------------------------------------- VARIABLES ---------------------------------------------*/
    
    var delegate:AddingThemeDelegate!
    
    var disciplineAvailables : [String] = []
    
    let labelNew = LabelTitleFolder(myText : "Nouveau")
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        tf.placeholder = "Cliquez ici"
        return tf
    }()
    
    let bottomLineTextField : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let buttonValidate = ButtonInMenus(text: "AJOUTER", backgroundColor: UIColor(r: 152, g: 152, b: 152))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
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
    
    func handleAdd() {
        if let text = textField.text {
            if !(text.isEmpty) {
                delegate.sendTheme(theme: text)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setupButtonValidate() {
        buttonValidate.topAnchor.constraint(equalTo: bottomLineTextField.bottomAnchor, constant: 60).isActive = true
        buttonValidate.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonValidate.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        buttonValidate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonValidate.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
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
        labelNew.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        labelNew.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        labelNew.widthAnchor.constraint(equalToConstant: 100).isActive = true
        labelNew.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
}
