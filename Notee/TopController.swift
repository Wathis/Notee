//
//  TopController.swift
//  Notee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class TopController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    /*------------------------------------ CONSTANTS ---------------------------------------------*/
    
    let reuseIdentifier = "cellClass"
    
    /*------------------------------------ VARIABLES ---------------------------------------------*/
    
    var classes : [String] = ["6ème","5ème","4ème","3ème","Seconde","1ère","Terminale","D.U.T. Informatique"]
    var timerAdd : Timer?
    
    lazy var themeTableView : UITableView = {
        var tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.showsVerticalScrollIndicator = false
        return tv
    }()

    var commingSoon : UILabel = {
        let label = UILabel()
        label.text = "Bientôt disponible ..."
        label.font = UIFont(name: "Helvetica", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 86, g: 90, b: 97)
        label.textAlignment = .center
        return label
    }()
    
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup back ground color
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = "Notee top"
        self.view.addSubview(commingSoon)
        isAdmin()
        commingSoon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        commingSoon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
        commingSoon.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        commingSoon.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        view.addSubview(themeTableView)
//        themeTableView.register(ClassCell.self, forCellReuseIdentifier: reuseIdentifier)
//        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isAdmin()
    }
    
    func isAdmin() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("members/\(uid)").observe(.value, with: { (snapshot) in
            guard let datas = snapshot.value as? NSDictionary, let admin = datas["admin"] as? Bool else {
                return
            }
            if (admin){
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "godmode"), style: .plain, target: self, action: #selector(self.handleGodMode))
            }
        })
    }
    
    func handleGodMode() {
        present(UINavigationController(rootViewController: GodModeController()), animated: true, completion: nil)
    }
    
    /*---------------------------------- FUNCTIONS BACKEND ------------------------------------------*/
    
    
    /*------------------------------------- HANDLE BUTTONS --------------------------------------------*/
    
    func handleLogout () {
        present(ConnectionController(), animated: true, completion: nil)
    }
    
    /*---------------------------------- TABLE VIEW DATA SOURCE ----------------------------------------*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 75
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell:ClassCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)! as! ClassCell
        cell.setText(text: classes[indexPath.row])
        return cell
        
    }
    func insertRow(timer : Timer) {
        themeTableView.insertRows(at: [timer.userInfo as! IndexPath], with: .automatic)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    /*---------------------------------- TABLE VIEW DELEGATE ----------------------------------------*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = SectionsController()
//        controller.theme = classes[indexPath.row]
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /*------------------------------------ CONSTRAINT --------------------------------------------------*/
    func setupTableView() {
        themeTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        themeTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        themeTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        themeTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        themeTableView.separatorStyle = .none
        
    }
}
