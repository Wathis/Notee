//
//  CommandTableViewController.swift
//  Notee
//
//  Created by Mathis Delaunay on 02/07/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class GodModeController:UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate {
    
    
    /*--------------------------------------- VARIABLES ---------------------------------------------*/
    
    let cellId = "cellComand"
    var commands = [String]()
    
    lazy var commandTableView : UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.backgroundColor =  UIColor(r: 227, g: 231, b: 228)
        return tv
    }()
    
    let commentTextFieldContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        return view
    }()
    
    var commentTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .white
        tf.attributedPlaceholder = NSAttributedString(string: "Écrire un commentaire...", attributes: [NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)])
        tf.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        return tf
    }()
    
    let buttonGo : UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
        return button
    }()
    
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = "God mode"
        hideKeyboardWhenTappedAround()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        self.view.addSubview(commandTableView)
        self.view.addSubview(commentTextFieldContainerView)
        setupTableView()
        setupContainerView()
        self.commands.append("Welcome in your god mode")
        buttonGo.addTarget(self, action: #selector(handleGo), for: .touchUpInside)
        
        //Observer on keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotificationWillHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /*------------------------------------ HANDLE BUTTONS ---------------------------------------------*/
    
    func handleGo () {
        guard let command = self.commentTextField.text?.uppercased() else {
            return
        }
        if command == "delete all sheets".uppercased() || command == "d a s".uppercased() {
            Database.database().reference().child("sheets").removeValue(completionBlock: { (error, refData) in
                Database.database().reference().child("theme-sheets").removeValue(completionBlock: { (error, refD) in
                    if error != nil {
                        self.commands.append("Failed to delete all sheets")
                    } else {
                        self.commands.append("Deleted all seets successfuly")
                    }
                    self.commandTableView.reloadData()
                })
            })
        }
        var index = command.index(command.startIndex, offsetBy: 2)
        var subStr = command.substring(to: index)
        if subStr == "op".uppercased() {
            let index = command.index(command.startIndex, offsetBy: 3)
            let person = command.substring(from: index)
            op(memberName: person)
        }
        index = command.index(command.startIndex, offsetBy: 4)
        subStr = command.substring(to: index)
        if subStr == "deop".uppercased() {
            let index = command.index(command.startIndex, offsetBy: 5)
            let person = command.substring(from: index)
            deop(memberName : person)
        }
        
        view.endEditing(true)
    }
    
    func op(memberName: String) {
        Database.database().reference().child("members").observe(.value, with: { (snapshot) in
            guard let datas = snapshot.value as? NSDictionary else {
                return
            }
            for val in datas {
                print(val)
                guard let member = val.value as? NSDictionary, let memberPseudo = member["pseudo"] as? String else {
                    return
                }
                if(memberPseudo.uppercased() == "@" + memberName){
                    guard let uidMember = val.key as? String else {
                        return
                    }
                    self.promotUID(memberUID: uidMember, action: true, memberPseudo: memberPseudo)
                }
            }
        })
    }
    
    func promotUID(memberUID : String,action: Bool,memberPseudo : String) {
        let values = ["admin" : action]
        Database.database().reference().child("members/\(memberUID)").updateChildValues(values, withCompletionBlock: { (error, dataRef) in
            if error != nil {
                self.commands.append("Promotion of \(memberPseudo) refused : " + error!.localizedDescription)
            } else {
                self.commands.append("Acion on \(memberPseudo) successfuly done")
            }
            self.commandTableView.reloadData()
        })
    }
    
    func deop(memberName : String){
        Database.database().reference().child("members").observe(.value, with: { (snapshot) in
            guard let datas = snapshot.value as? NSDictionary else {
                return
            }
            for value in datas {
                guard let member = value.value as? NSDictionary, let memberPseudo = member["pseudo"] as? String else {
                    return
                }
                if(memberPseudo.uppercased() == "@" + memberName){
                    guard let uidMember = value.key as? String else {
                        return
                    }
                    self.promotUID(memberUID: uidMember, action: false, memberPseudo: memberPseudo)
                }
            }
        })
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame : CGRect = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            UIView.animate(withDuration: 0.1, animations: {
                self.bottomLayout?.constant = -keyboardFrame.size.height
            })
            self.commentTextField.layoutIfNeeded()
        }
    }
    
    func handleKeyboardNotificationWillHide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomLayout?.constant = 0
        })
        self.commentTextFieldContainerView.layoutIfNeeded()
    }
    
    /*---------------------------------- TABLE VIEW DATA SOURCE ----------------------------------------*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ElementCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = "\(Date().currentTimeZoneDate())"
        cell.detailTextLabel?.text = commands[indexPath.row]
        return cell
    }
    
    /*---------------------------------- TEXTFIELD DELEGATE ----------------------------------------*/
    
    
    
    /*------------------------------------ CONSTRAINT ---------------------------------------------*/
    
    var bottomLayout : NSLayoutConstraint?
    var widthButtonGo  = CGFloat(40)
    func setupContainerView() {
        bottomLayout = commentTextFieldContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomLayout?.isActive = true
        commentTextFieldContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        commentTextFieldContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        commentTextFieldContainerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.commentTextFieldContainerView.addSubview(commentTextField)
        self.commentTextFieldContainerView.addSubview(buttonGo)
        
        commentTextField.centerYAnchor.constraint(equalTo: self.commentTextFieldContainerView.centerYAnchor).isActive = true
        commentTextField.leftAnchor.constraint(equalTo: self.commentTextFieldContainerView.leftAnchor, constant : 10).isActive = true
        commentTextField.widthAnchor.constraint(equalTo: commentTextFieldContainerView.widthAnchor, constant : -widthButtonGo).isActive = true
        commentTextField.heightAnchor.constraint(equalTo: commentTextFieldContainerView.heightAnchor).isActive = true
        
        buttonGo.rightAnchor.constraint(equalTo: self.commentTextFieldContainerView.rightAnchor).isActive = true
        buttonGo.lastBaselineAnchor.constraint(equalTo: commentTextField.lastBaselineAnchor).isActive = true
        buttonGo.heightAnchor.constraint(equalTo: self.commentTextFieldContainerView.heightAnchor).isActive = true
        buttonGo.widthAnchor.constraint(equalToConstant: widthButtonGo).isActive = true
    }
    
    
    func setupTableView() {
        commandTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        commandTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        commandTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        commandTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0).isActive = true
    }
    
    
    
}
