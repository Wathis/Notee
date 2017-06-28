//
//  Plug.swift
//  Notee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

struct Plug {
    var id : Int?
    var description = ""
    var version : Int?
    var theme : String?
    var section : String?
    var subject : String?
    var title = ""
    var photo : UIImage?
    var member : Member?
}

struct Comment {
    var Member : Member?
    var commentText : String?
}
