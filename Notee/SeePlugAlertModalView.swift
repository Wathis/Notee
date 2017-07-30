//
//  SeePlugAlert.swift
//  Notee
//
//  Created by Mathis Delaunay on 30/07/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class SeePlugAlertModalView : UIViewController {
    
    
    var titleCancelButton : String? {
        didSet {
            buttonCancel.setTitle(titleCancelButton, for: .normal)
        }
    }
    
    
    var titleCancelConfirmation : String? {
        didSet {
            buttonConfirmation.setTitle(titleCancelConfirmation, for: .normal)
        }
    }
    
    var titleOfAlert : String? {
        didSet {
            self.titleLabel.text = self.titleOfAlert
        }
    }
    
    var descriptionOfAlert : String? {
        didSet {
            self.descriptionLabel.text = self.descriptionOfAlert
        }
    }
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.view.isOpaque = false
        self.buttonCancel.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        self.buttonConfirmation.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        self.view.addSubview(containerView)
        self.containerView.addSubview(buttonCancel)
        self.containerView.addSubview(buttonConfirmation)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/3),
            
            titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.containerView.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor,constant: -10),
            descriptionLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: self.containerView.widthAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            buttonCancel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: -60),
            buttonCancel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -20),
            buttonCancel.widthAnchor.constraint(equalToConstant: 100),
            buttonCancel.heightAnchor.constraint(equalToConstant: 40),
            
            buttonConfirmation.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: 60),
            buttonConfirmation.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -20),
            buttonConfirmation.widthAnchor.constraint(equalToConstant: 100),
            buttonConfirmation.heightAnchor.constraint(equalToConstant: 40),
            ])
    }
    
    var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.opacity = 1
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowRadius = 2
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
    
    var descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "Il vous reste 12 N"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 17)
        label.textAlignment = .center
        label.textColor =  UIColor(r: 149, g: 152, b: 154)
        return label
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
