//
//  myButtons.swift
//  Plugee
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
