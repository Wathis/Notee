//
//  SeePlugAlert.swift
//  Notee
//
//  Created by Mathis Delaunay on 30/07/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class PlugAlertModalView : UIViewController {
    
    var currentPlug : Plug?
    var delegate : DelegateAlertViewer?
    
    var noteeCoinsAvailables : Int = 0 {
        didSet {
            self.descriptionOfAlert = "Il vous reste \(noteeCoinsAvailables) N"
        }
    }
    
    var cost : Int = 0 {
        didSet {
            titleConfirmationButton = "\(self.cost) N"
        }
    }
    
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
    
    var descriptionOfAlert : String? {
        didSet {
            self.descriptionTextView.text = self.descriptionOfAlert
        }
    }
    
    var delegateForBuy : NewsController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    init(title : String, description : String) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.titleOfAlert = title
        self.descriptionOfAlert = description
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
        buttonCancel.setAttributedTitle(NSAttributedString(string: titleCancelButton, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBold", size: 18) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        buttonConfirmation.setAttributedTitle(NSAttributedString(string: titleConfirmationButton, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBold", size: 18) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        self.titleLabel.text = self.titleOfAlert
        self.descriptionTextView.text = self.descriptionOfAlert
        self.buttonCancel.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        self.buttonConfirmation.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func addTargetForPlugViewer() {
        cost = 1
        self.buttonConfirmation.removeTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        self.buttonConfirmation.addTarget(self, action: #selector(handlePay), for: .touchUpInside)
    }
    
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
    
    
    func handlePay() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let refMember = Database.database().reference().child("members/\(uid)")
        
        refMember.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let values = snapshot.value as? NSDictionary, var noteeCoins = values["noteeCoins"] as? Int else {
                
                return
            }
            if noteeCoins - self.cost >= 0 {
                noteeCoins = noteeCoins - self.cost
                refMember.updateChildValues(["noteeCoins" : noteeCoins])
                self.goToViewer()
            } else {
                self.notEnoughCoins()
            }
        })
    }
    
    func goToViewer() {
        guard let delegate = self.delegate, let plug = currentPlug else {handleCancel(); return;}
        dismiss(animated: true, completion: nil)
        delegate.presentViewer(plug: plug)
    }
    
    func notEnoughCoins() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (finish) in
            UIView.animate(withDuration: 0.3) {
                self.containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            self.titleOfAlert = "Stock épuisé, veuillez soit"
            self.descriptionOfAlert = "- Partagez des fiches de révisions\n- Gagnez des étoiles sur vos fiches\n- Recharger votre compte"
            self.titleConfirmationButton = "RECHARGER"
            self.buttonConfirmation.removeTarget(self, action: #selector(self.handlePay), for: .touchUpInside)
            self.buttonConfirmation.addTarget(self, action: #selector(self.handleBuy), for: .touchUpInside)
        }
    }
    
    func handleBuy() {
        self.handleCancel()
        delegateForBuy?.tabBarController?.selectedIndex = 3
    }
    
    func setupViews() {
        self.view.addSubview(containerView)
        self.containerView.addSubview(buttonCancel)
        self.containerView.addSubview(buttonConfirmation)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(descriptionTextView)
        
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
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        descriptionTextView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        descriptionTextView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    //To center vertically textFields
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let textView = object as! UITextView
        var topCorrect = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        textView.contentInset.top = topCorrect
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
