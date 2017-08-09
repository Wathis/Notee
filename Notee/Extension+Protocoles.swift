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

protocol DelegateAlertViewer {
    func presentViewer(plug : Plug)
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

extension NSDate {
    func getTimeFrom(date : NSDate) -> String {
        var data = ""
        
        let secondsNow = Int(self.timeIntervalSince1970)
        let secondsPost = Int(date.timeIntervalSince1970)
        let secondFromNowToPost = secondsNow - secondsPost
        let minute = 60
        let hour = minute * 60
        let day = hour * 24
        let week = day * 7
        let month = week * 4
        let year = month * 12
        
        if secondFromNowToPost < minute {
            data += "à l'instant"
        } else if (secondFromNowToPost < hour) {
            let minutes = Int(secondFromNowToPost / minute)
            data += "il y a \(minutes) " + (minutes == 1 ? "minute" : "minutes")
        } else if (secondFromNowToPost < day) {
            let hours = Int(secondFromNowToPost / hour)
            data += "il y a \(hours) " + (hours == 1 ? "heure" : "heures")
        } else if (secondFromNowToPost < week){
            let days = Int(secondFromNowToPost / day)
            data += "il y a \(days) " + (days == 1 ? "jour" : "jours")
        } else if (secondFromNowToPost < month) {
            let weeks = Int(secondFromNowToPost / week)
            data += "il y a \(weeks) " + (weeks == 1 ? "semaine" : "semaines")
        } else if (secondFromNowToPost < year) {
            let months = Int(secondFromNowToPost / month)
            data += "il y a \(months) " + (months == 1 ? "mois" : "mois")
        } else {
            let years = Int(secondFromNowToPost / year)
            data += "il y a \(years) " + (years == 1 ? "an" : "ans")
        }
        
        
        return data
    }
}

protocol SendTagsDelegate {
    func sendTags(tags : [String])
    
}

protocol ChangeUserDataDelegate {
    func receiveMailChanged(email : String)
    func receivePseudoChanded(pseudo : String) 
}

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}

extension UIButton {
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        userClicked()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        userTapped()
    }
    
    func userClicked() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func userTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (finish) in
           
        }
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(attributes: [NSFontAttributeName: font])
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
extension Date {
    func currentTimeZoneDate() -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dtf.string(from: self)
    }
}
