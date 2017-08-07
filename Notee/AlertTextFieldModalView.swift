//
//  AlertTextFieldModalView.swift
//  Notee
//
//  Created by Mathis Delaunay on 08/08/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class AlertTextFieldModalView : UIViewController {
    
    var titleCancelButton : String = "" {
        didSet {
            buttonCancel.setAttributedTitle(NSAttributedString(string: titleCancelButton, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBold", size: 18) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        }
    }
    
    var titleConfirmationButton : String = "" {
        didSet {
            buttonConfirmation.setAttributedTitle(NSAttributedString(string: titleConfirmationButton, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBold", size: 18) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        }
    }
    
    var titleOfAlert : String? {
        didSet {
            self.titleLabel.text = self.titleOfAlert
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    init(title : String, secureEntry : Bool) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.titleOfAlert = title
        self.textField.isSecureTextEntry = secureEntry
        self.titleCancelButton = "Retour"
        self.titleConfirmationButton = "D'accord"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.view.isOpaque = false
        self.view.layer.opacity = 0
        self.hideKeyboardWhenTappedAround()
        buttonCancel.setAttributedTitle(NSAttributedString(string: titleCancelButton, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBold", size: 18) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        buttonConfirmation.setAttributedTitle(NSAttributedString(string: titleConfirmationButton, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBold", size: 18) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        self.titleLabel.text = self.titleOfAlert
        self.buttonCancel.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        tf.placeholder = "Mot de passe"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.containerView.layer.opacity = 1
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layer.opacity = 1
        }
    }
    
    func handleCancel() {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.000001, y: 0.000001)
            self.view.layer.opacity = 0
        }) { (finish) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func setupViews() {
        self.view.addSubview(containerView)
        self.containerView.addSubview(buttonCancel)
        self.containerView.addSubview(buttonConfirmation)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(descriptionTextView)
        self.containerView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 250),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.containerView.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionTextView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor,constant: -10),
            descriptionTextView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.buttonCancel.topAnchor),
            descriptionTextView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, multiplier: 95/100),
            
            buttonCancel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: -60),
            buttonCancel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -20),
            buttonCancel.widthAnchor.constraint(equalToConstant: 100),
            buttonCancel.heightAnchor.constraint(equalToConstant: 40),
            
            buttonConfirmation.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: 60),
            buttonConfirmation.centerYAnchor.constraint(equalTo: self.buttonCancel.centerYAnchor),
            buttonConfirmation.widthAnchor.constraint(equalToConstant: 100),
            buttonConfirmation.heightAnchor.constraint(equalToConstant: 40),
            
            textField.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            textField.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, multiplier : 8/10),
            textField.heightAnchor.constraint(equalToConstant: 50)
        
            ])
    }
    
    var containerView : UIView = {
        let view = UIView()
        view.layer.opacity = 1
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowRadius = 2
        view.layer.opacity = 0
        return view
    }()
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Consulter la fiche ?"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20)
        label.textColor =  UIColor(r: 149, g: 152, b: 154)
        label.textAlignment = .center
        return label
    }()
    
    var descriptionTextView : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 17)
        tv.textAlignment = .center
        tv.textColor =  UIColor(r: 149, g: 152, b: 154)
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    var buttonCancel : UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "ANNULER", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBold", size: 18) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        button.backgroundColor = UIColor.init(r: 230, g: 135, b: 140)
        return button
    }()
    
    var buttonConfirmation : UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "1 N", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBold", size: 18) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        button.backgroundColor = UIColor.init(r: 75, g: 214, b: 199)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
}
