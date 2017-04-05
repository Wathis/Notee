//
//  newPlugCell.swift
//  Plugee
//
//  Created by Mathis Delaunay on 26/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class newPlugView: UIView {
    
    var versionText : String = "Papier\n"
    var themeText : String = "Histoire\n"
    var sectionText : String = "La première guerre mondiale\n"
    var subjectText : String = "La bataille de verdun\n"
    var descriptionText : String = "Ce plug est une prise de note de mon cours sur la bataille de Verdun."
    
    var stackViewForButtons : UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var contentOfPlug : UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = UIColor(r: 86, g: 90, b: 98)
        tv.isUserInteractionEnabled = false
        tv.backgroundColor = .blue
        return tv
    }()
    
    let buttonAdd : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(r: 152, g: 152, b: 152)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("Ajouter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let buttonReport : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(r: 152, g: 152, b: 152)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("Ajouter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var titleOfNewPlug : UILabel = {
        let label = UILabel()
        var attributedText = NSMutableAttributedString(string: "@MathisDelaunay", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)])
        attributedText.append(NSAttributedString(string: " à ajouté un Plug.", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)]))
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
        return view
    }()
    
    
    var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(headerView)
        //<loadInformations()
        setupViews()
        setShadowToView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShadowToView() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 3
    }
    
    
    func setupViews() {
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
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
        
        let buttonAddContainerView = UIView()
        buttonAddContainerView.backgroundColor = .red
        let buttonReportContainerView = UIView()
        buttonReportContainerView.backgroundColor = .blue
        
        stackViewForButtons.addArrangedSubview(buttonAddContainerView)
        stackViewForButtons.addArrangedSubview(buttonReportContainerView)
        stackViewForButtons.backgroundColor = .blue
        
        self.addSubview(stackViewForButtons)
        
        stackViewForButtons.bottomAnchor.constraint(equalTo: self.bottomAnchor ,constant: 10).isActive = true
        stackViewForButtons.widthAnchor.constraint(equalTo: self.widthAnchor).isActive  = true
        stackViewForButtons.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackViewForButtons.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
        self.addSubview(contentOfPlug)
        
        contentOfPlug.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentOfPlug.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
        contentOfPlug.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10).isActive = true
        contentOfPlug.heightAnchor.constraint(equalToConstant: self.frame.height / 2).isActive = true
        
    }
    
}
