//
//  newPlugCell.swift
//  Notee
//
//  Created by Mathis Delaunay on 26/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class newPlugView: UIView {
    
    var versionText : String = "Papier" {
        didSet {
            self.refreshAttributeString()
        }
    }
    var disciplineText: String = "Histoire\n\n" {
        didSet {
            self.refreshAttributeString()
        }
    }
    var themeText : String = "La bataille de verdun\n\n" {
        didSet {
            self.refreshAttributeString()
        }
    }
    var descriptionText : String = "Ce plug est une prise de note de mon cours sur la bataille de Verdun." {
        didSet {
            self.refreshAttributeString()
        }
    }
    
    lazy var contentOfPlug : UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = UIColor(r: 86, g: 90, b: 98)
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    let buttonAdd : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(r: 152, g: 152, b: 152)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setAttributedTitle( NSAttributedString(string: "Ajouter", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 13) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let buttonReport : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(r: 152, g: 152, b: 152)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setAttributedTitle( NSAttributedString(string: "Signaler", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 13) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var titleOfNewPlug : UILabel = {
        let label = UILabel()
        var attributedText = NSMutableAttributedString(string: "@MathisDelaunay", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 14) as Any])
        attributedText.append(NSAttributedString(string: " à ajouté un Plug.", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 13) as Any]))
        label.attributedText = attributedText
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var headerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    var underHeaderView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var favoriteImage : UIImageView = {
        var image = UIImageView()
        image.image = #imageLiteral(resourceName: "favoriteButtonColored")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var numberOfFavoriteLabel : UILabel = {
        let label = UILabel()
        label.text = "132"
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
        label.textColor = UIColor(r: 86, g: 90, b: 98)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(headerView)
        contentOfPlug.attributedText = loadAttributedString()
        setupViews()
        setShadowToView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshAttributeString() {
        self.contentOfPlug.attributedText = loadAttributedString()
    }
    
    func loadAttributedString() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "Version : ", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium",size : 13 ) as Any, NSForegroundColorAttributeName : UIColor(r:86, g:90, b: 98 ) as Any])
        attributedString.append(NSAttributedString(string: versionText, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light",size : 13 ) as Any, NSForegroundColorAttributeName : UIColor(r:86, g:90, b: 98 ) as Any]))
        attributedString.append(NSAttributedString(string: "\n\nMatière : ", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium",size : 13 ) as Any, NSForegroundColorAttributeName : UIColor(r:86, g:90, b: 98 ) as Any]))
        attributedString.append(NSAttributedString(string: disciplineText, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light",size : 13 ) as Any, NSForegroundColorAttributeName : UIColor(r:86, g:90, b: 98 ) as Any]))
        attributedString.append(NSAttributedString(string: "\n\nThème : ", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium",size : 13 ) as Any, NSForegroundColorAttributeName : UIColor(r:86, g:90, b: 98 ) as Any]))
        attributedString.append(NSAttributedString(string: themeText, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light",size : 13 ) as Any, NSForegroundColorAttributeName : UIColor(r:86, g:90, b: 98 ) as Any]))
        attributedString.append(NSAttributedString(string: "\n\nDescription :\n\n", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium",size : 13 ) as Any, NSForegroundColorAttributeName : UIColor(r:86, g:90, b: 98 ) as Any]))
        attributedString.append(NSAttributedString(string: descriptionText, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light",size : 13 ) as Any, NSForegroundColorAttributeName : UIColor(r:86, g:90, b: 98 ) as Any]))
        return attributedString
    }
    
    func setShadowToView() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 5
    }
    
    
    func setupViews() {
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.addSubview(underHeaderView)
        
        underHeaderView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        underHeaderView.widthAnchor.constraint(equalTo: headerView.widthAnchor).isActive = true
        underHeaderView.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 1/2).isActive = true
        underHeaderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        self.addSubview(titleOfNewPlug)
        
        titleOfNewPlug.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        titleOfNewPlug.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        titleOfNewPlug.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier: 9/10).isActive = true
        titleOfNewPlug.heightAnchor.constraint(equalTo: self.headerView.heightAnchor).isActive = true
        
        self.addSubview(buttonAdd)
        
        buttonAdd.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        buttonAdd.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        buttonAdd.heightAnchor.constraint(equalToConstant: 25).isActive = true
        buttonAdd.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        
        self.addSubview(buttonReport)
        
        buttonReport.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        buttonReport.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        buttonReport.heightAnchor.constraint(equalToConstant: 25).isActive = true
        buttonReport.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        self.addSubview(contentOfPlug)
        
        contentOfPlug.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentOfPlug.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
        contentOfPlug.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10).isActive = true
        contentOfPlug.bottomAnchor.constraint(equalTo: self.buttonAdd.topAnchor, constant: -10).isActive = true
        
        self.addSubview(favoriteImage)
        
        favoriteImage.topAnchor.constraint(equalTo: contentOfPlug.topAnchor,constant : 5).isActive = true
        favoriteImage.rightAnchor.constraint(equalTo: contentOfPlug.rightAnchor).isActive = true
        favoriteImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        favoriteImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(numberOfFavoriteLabel)
        
        numberOfFavoriteLabel.centerYAnchor.constraint(equalTo: favoriteImage.centerYAnchor).isActive = true
        numberOfFavoriteLabel.rightAnchor.constraint(equalTo: favoriteImage.leftAnchor,constant : -5 ).isActive = true
        numberOfFavoriteLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        numberOfFavoriteLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
