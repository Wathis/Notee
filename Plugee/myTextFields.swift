//
//  myTextFields.swift
//  Plugee
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
