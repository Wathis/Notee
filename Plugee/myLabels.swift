//
//  myLabels.swift
//  Plugee
//
//  Created by Mathis Delaunay on 05/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class myLabel : UILabel {
    init(myText text : String) {
        super.init(frame: CGRect(x: 12, y: 12, width: 12, height: 12))
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name: "Helvetica", size: 15)
        self.font = UIFont.boldSystemFont(ofSize: 15)
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
