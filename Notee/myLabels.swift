//
//  myLabels.swift
//  Notee
//
//  Created by Mathis Delaunay on 05/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class InformationMessage  : UILabel {
    
    var message : String? {
        didSet {
            self.text = message
        }
    }
    
    init(information : String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.text = information
        self.font = UIFont(name: "Helvetica", size: 20)
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = UIColor(r: 86, g: 90, b: 97)
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LabelTitleFolder : UILabel {
    init(myText text : String) {
        super.init(frame: CGRect(x: 12, y: 12, width: 12, height: 12))
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name : "HelveticaNeue-Bold",size : 15)
        self.textColor = UIColor(r: 86, g: 90, b: 98)
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CopyrightWathisLabel : UILabel {
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.text = "© Copyright Wathis 2017"
        self.font = UIFont(name: "Helvetica-Light", size: 14)
        self.textColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ForgottenPasswordLabel : UILabel {
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.text = "Mot de passe oublié ?"
        self.font = UIFont(name: "Helvetica-Light", size: 14)
        self.textColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .right
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LabelTitleConnectionScreen : UILabel {
    init(text : String,size : CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.text = text
        self.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: size)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .center
        self.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
