//
//  Extension+Protocoles.swift
//  Notee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

protocol AddingDisciplineDelegate {
    func sendString(disciplineName : String)
}
protocol AddingPlugDelegate {
    func sendPlug(plug : Plug)
}

protocol AddingThemeDelegate {
    func sendTheme(theme : String)
}
protocol LogoutUserDelegate {
    func refreshPage() 
}

extension UIColor {
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b/255, alpha: 1)
    }
}

extension UIViewController { //Permet quand on tape ailleurs -> plus de clavier
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
