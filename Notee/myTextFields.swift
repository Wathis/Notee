//
//  myTextFields.swift
//  Notee
//
//  Created by Mathis Delaunay on 05/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class TextFieldLoginRegister : UIView, UITextFieldDelegate {
    
    var text : String?
    
    lazy var textField : UITextField = {
        var tf = UITextField()
        tf.font = UIFont(name: "Helvetica-Light",size: 20)
        tf.textColor = .white
        tf.delegate = self
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(placeholderText : String,isSecureEntry : Bool){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupViews()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        if let fontName = UIFont(name: "Helvetica-Light",size: 20) {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), NSFontAttributeName : fontName])
        } else {
            textField.placeholder = placeholderText
        }
        if (isSecureEntry){
             textField.isSecureTextEntry = true
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(placeholderText : String,isSecureEntry : Bool, delegate : UITextFieldDelegate){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupViews()
        textField.delegate = delegate
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        if let fontName = UIFont(name: "Helvetica-Light",size: 20) {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), NSFontAttributeName : fontName])
        } else {
            textField.placeholder = placeholderText
        }
        if (isSecureEntry){
            textField.isSecureTextEntry = true
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func textFieldDidChange() {
        text = textField.text
    }
    
    func setupViews() {
        self.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(separatorLine)
        
        separatorLine.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLine.centerXAnchor.constraint(equalTo: textField.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TextFieldAdding : UIView {
    var text : String? {
        didSet {
            self.textField.text = text
        }
    }
    
    lazy var textField : UITextField = {
        var tf = UITextField()
        tf.font = UIFont(name: "Helvetica-Light",size: 20)
        tf.textColor = UIColor(r: 86, g: 90, b: 98)
        tf.autocapitalizationType = .none
        tf.textAlignment = .left
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(placeholderText : String){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupViews()
        if let fontName = UIFont(name: "Helvetica-Light",size: 20) {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName :  UIColor(red: 86 / 255, green: 90 / 255, blue: 98 / 255, alpha: 0.5), NSFontAttributeName : fontName])
        } else {
            textField.placeholder = placeholderText
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(separatorLine)
        
        separatorLine.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLine.centerXAnchor.constraint(equalTo: textField.centerXAnchor).isActive = true
    }
}
