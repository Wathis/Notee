//
//  ObservorNoteeMessage.swift
//  Notee
//
//  Created by Mathis Delaunay on 06/08/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class ObservorNoteeMessage  {
    
    var parentViewController : UIViewController?
    
    init(parent : UIViewController) {
        self.parentViewController = parent
    }
    
    func beginObserve() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("members/\(uid)/message").observe(.value, with: { (snaphot) in
            guard let message = snaphot.value as? String else {
                return
            }
            self.presentMessageFromNotee(message: message)
            Database.database().reference().child("members/\(uid)/message").removeValue()
        })
    }
    
    func presentMessageFromNotee(message: String) {
        let alert = PlugAlertModalView()
        alert.titleOfAlert = "Message de Notee"
        alert.descriptionOfAlert = message
        alert.titleCancelButton = "Annuler"
        parentViewController?.present(alert, animated: false, completion: {
            alert.titleConfirmationButton = "D'accord"
        })
    }
}
