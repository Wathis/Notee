//
//  myButtons.swift
//  Notee
//
//  Created by Mathis Delaunay on 05/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ButtonLoginRegister : UIButton {
    init(text : String,backgroundColor : UIColor,textColor : UIColor) {
        super.init(frame: CGRect(x: 12, y: 12, width: 12, height: 12))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor(r: 0, g: 0, b: 0).cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ButtonInMenus : UIButton {
    init(text : String, backgroundColor : UIColor) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setAttributedTitle(NSAttributedString(string: text.uppercased(), attributes: [NSForegroundColorAttributeName : UIColor.white as Any, NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 17) as Any]), for: .normal)
        self.tintColor = .white
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 25
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ButtonAddSheet : UIButton {
    var sheet : Plug?
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
    }
    
    func changeColorOfButton() {
        guard let isAdded = self.sheet?.isAdded else {return}
        if isAdded {
            self.backgroundColor = UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
            self.setAttributedTitle( NSAttributedString(string: "Ajouté", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 13) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        } else {
            self.backgroundColor = UIColor(r: 152, g: 152, b: 152)
            self.setAttributedTitle( NSAttributedString(string: "Ajouter", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 13) as Any,NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ButtonReport : UIButton {
    
    init(text : String ){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.setAttributedTitle(NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor(r:86,g:90,b:98) as Any , NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 15) as Any]), for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
