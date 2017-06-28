//
//  addThemeController.swift
//  Notee
//
//  Created by Mathis Delaunay on 16/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class addDisciplineController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    /*--------------------------------------- VARIABLES ---------------------------------------------*/

    var delegate:AddingDisciplineDelegate!
    
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
    
    lazy var pickerViewDiscipline : UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()
    
    let buttonValidate = ButtonInMenus(text: "AJOUTER", backgroundColor: UIColor(r: 152, g: 152, b: 152))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.title = "Ajouter"
        laodDiscipline()
        textField.inputView = pickerViewDiscipline
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
    
    func laodDiscipline()  {
        let ref = Database.database().reference().child("discipline")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let values = snapshot.value as? NSDictionary else {
                return
            }
            for value in values {
                if let key = value.key as? String {
                    self.disciplineAvailables.append(key)
                }
            }
            self.pickerViewDiscipline.reloadAllComponents()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    func handleCreate() {
        if let text = textField.text {
            if !(text.isEmpty) {
                delegate.sendString(disciplineName: text)
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
        labelNew.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        labelNew.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        labelNew.widthAnchor.constraint(equalToConstant: 100).isActive = true
        labelNew.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return disciplineAvailables.count
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return disciplineAvailables[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = disciplineAvailables[row]
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}