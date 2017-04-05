//
//  ViewController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 05/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ConnectionController : UIViewController {
    
    var labelOnTop : UILabel = {
        var label = UILabel()
        label.text = ""
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        
    }

}
