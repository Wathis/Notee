//
//  TopController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

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

    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup back ground color
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = "Plugee top"
        view.addSubview(themeTableView)
        themeTableView.register(ClassCell.self, forCellReuseIdentifier: reuseIdentifier)
        setupTableView()
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
        let controller = SectionsController()
        controller.theme = classes[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
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
