//
//  Member.swift
//  Notee
//
//  Created by Mathis Delaunay on 23/06/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class Member: NSObject {
    
    var nom : String?
    var id : String?
    var prenom : String?
    var pseudo : String?
    var profilImage : UIImage?
    var email : String?
    var profilImageUrl : String?
    
    init(id : String ) {
        self.id = id
    }
    
    init(id : String, pseudo : String ) {
        self.id = id
        self.pseudo = pseudo
    }
    
    init(id : String, pseudo : String, urlImage : String ) {
        self.id = id
        self.pseudo = pseudo
        self.profilImageUrl = urlImage
    }
    
    init(id : String,email : String, pseudo : String, urlImage : String ) {
        self.id = id
        self.pseudo = pseudo
        self.email = email
        self.profilImageUrl = urlImage
    }
    
    init(id : String, email : String) {
        self.email = email
        self.id = id
    }
    init(nom: String, prenom: String, pseudo: String, profilImage : UIImage) {
        self.nom = nom
        self.prenom = prenom
        self.pseudo = pseudo
        self.profilImage = profilImage
    }
}
