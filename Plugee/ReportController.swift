//
//  ReportController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 13/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ReportController: UIViewController {

    let heightOfButtonReport = 35
    
    var buttonsReport : [ButtonReport] = {
        var buttons = [ButtonReport]()
        buttons.append(ButtonReport(text: "Le texte n'est pas lisible"))
        buttons.append(ButtonReport(text: "Abus de langage"))
        buttons.append(ButtonReport(text: "Mauvais sujet"))
        buttons.append(ButtonReport(text: "Atteinte à la vie privée"))
        buttons.append(ButtonReport(text: "Autres"))
        return buttons
    }()
    
    let buttonCancel = ButtonInMenus(text: "ANNULER", backgroundColor: UIColor(r: 152, g: 152, b: 152))
    
    let confirmationMessage : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Votre signalement à été envoyé", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 15) as Any,
                                                                                                             NSForegroundColorAttributeName : UIColor(r:86,g:90,b:98) as Any])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = "Motif signalement"
        var i = 0
        for button in buttonsReport {
            addConstraintsToButton(button: button, yPosition: i == 0 ? 30 : i * ( heightOfButtonReport + 15 ) + 30)
            button.addTarget(self, action: #selector(handlePattern), for: .touchUpInside)
            i += 1
        }
        
        buttonCancel.addTarget(self, action: #selector(handleCancel), for:.touchUpInside)
        
        self.view.addSubview(buttonCancel)
        
        buttonCancel.topAnchor.constraint(equalTo: buttonsReport[i - 1].bottomAnchor, constant:60).isActive = true
        buttonCancel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonCancel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10).isActive = true
        buttonCancel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func handlePattern() {
        
        UIView.animate(withDuration: 0.1, animations: {
            for button in self.buttonsReport {
                button.alpha = 0
            }
            self.buttonCancel.alpha = 0.0
        })
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(handleCancel), userInfo: nil, repeats: false)
        
        self.view.addSubview(confirmationMessage)
        self.confirmationMessage.alpha = 0
        
        confirmationMessage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        confirmationMessage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10).isActive = true
        confirmationMessage.heightAnchor.constraint(equalToConstant: CGFloat(heightOfButtonReport)).isActive = true
        confirmationMessage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        UIView.animate(withDuration: 0.1, animations: {
            self.confirmationMessage.alpha = 1
        })
        
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func addConstraintsToButton(button : ButtonReport,yPosition : Int) {
        self.view.addSubview(button)
        
        button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(yPosition)).isActive = true
        button.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10).isActive = true
        button.heightAnchor.constraint(equalToConstant: CGFloat(heightOfButtonReport)).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}
