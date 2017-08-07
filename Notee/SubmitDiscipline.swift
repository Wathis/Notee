//
//  SubmitDiscipline.swift
//  Notee
//
//  Created by Mathis Delaunay on 07/08/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import Firebase


class SubmitDiscipline : UIViewController {
    
    
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

    let buttonSubmit = ButtonInMenus(text: "PROPOSER", backgroundColor: UIColor(r: 152, g: 152, b: 152))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.title = "Proposition"
        self.view.addSubview(textField)
        self.view.addSubview(bottomLineTextField)
        self.view.addSubview(buttonSubmit)
        hideKeyboardWhenTappedAround()
        setupTextField()
        setupBottomLineTextField()
        setupButtonValidate()
    }
    
    func handleSubmit() {
        guard let discipline = self.textField.text?.lowercased() else {return}
        let values = ["/disciplineNeeded/\(discipline.uppercaseFirst)" : true , "discipline/\(discipline.uppercaseFirst)" : true]
        Database.database().reference().updateChildValues(values)
        self.dismiss(animated: true, completion: nil)
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
