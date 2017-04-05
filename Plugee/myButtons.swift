//
//  myButtons.swift
//  Plugee
//
//  Created by Mathis Delaunay on 05/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class buttonLoginRegister : UIButton {
    init(text : String,backgroundColor : UIColor,textColor : UIColor) {
        super.init(frame: CGRect(x: 12, y: 12, width: 12, height: 12))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
