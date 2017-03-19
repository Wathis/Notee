//
//  Plug.swift
//  Plugee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

struct Plug {
    var id : Int?
    var description = ""
    var title = ""
    var photo : UIImage?
    var member : Member?
}

struct Member {
    var nom : String?
    var prenom : String?
    var pseudo : String?
}
