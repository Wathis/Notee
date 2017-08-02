//
//  parameterNewsOffOnCell.swift
//  Notee
//
//  Created by Mathis Delaunay on 03/08/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ParameterNewsOffOnCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    let enableNews : UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textForEnableNews : UILabel = {
        let label = UILabel()
        label.text = "Activer les notee news"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica-Neue", size: 20)
        label.textColor = UIColor(r: 86, g: 90, b: 98)
        label.textAlignment = .left
        return label
    }()
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(textForEnableNews)
        self.addSubview(enableNews)
        
        
        NSLayoutConstraint.activate([
            
            enableNews.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            enableNews.widthAnchor.constraint(equalToConstant: 50),
            enableNews.heightAnchor.constraint(equalToConstant: 35),
            enableNews.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10),
            
            textForEnableNews.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textForEnableNews.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10),
            textForEnableNews.rightAnchor.constraint(equalTo: self.enableNews.leftAnchor),
            textForEnableNews.heightAnchor.constraint(equalTo: self.heightAnchor)
            
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class SignOutCell : UITableViewCell {
    
    let buttonSignOut = ButtonInMenus(text: "Déconnexion", backgroundColor: UIColor(r: 230, g: 135, b: 140))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Remove the grey selection color
        self.selectionStyle = .none
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(buttonSignOut)
        
        
        NSLayoutConstraint.activate([
            
            buttonSignOut.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            buttonSignOut.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 4/5),
            buttonSignOut.heightAnchor.constraint(equalToConstant : 48),
            buttonSignOut.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


