//
//  Plug.swift
//  Notee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

struct Plug {
    var id : String?
    var description = ""
    var discipline = ""
    var theme = ""
    var title = ""
    var photo : UIImage?
    var member : Member?
    var urlImage : String?
    
    init() {
        
    }
    init(title : String, description : String, photo : UIImage ) {
        self.title = title
        self.description = description
        self.photo = photo
    }
    init(id : String,discipline : String, description : String, theme : String, title : String , member : Member, urlPhoto: String) {
        self.id =  id
        self.discipline = discipline
        self.description = description
        self.theme = theme
        self.title = title
        self.member = member
        self.urlImage = urlPhoto
    }
}

struct Comment {
    var Member : Member?
    var commentText : String?
}

struct Theme {
    var name : String?
    var id : String?
}
