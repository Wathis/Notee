//
//  HomeController.swift
//  Notee
//
//  Created by Mathis Delaunay on 14/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class HomeController: UIViewController,UITableViewDataSource,UITableViewDelegate, AddingSectionThemeDelegate {

/*------------------------------------ CONSTANTS ---------------------------------------------*/
    
    let reuseIdentifier = "cellTheme"
    
/*------------------------------------ VARIABLES ---------------------------------------------*/

    var theme : [String] = ["Français","Mathématiques","Anglais"]
    var timerAdd : Timer?
    var isConnected = false
    
    lazy var themeTableView : UITableView = {
        var tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let themeLabel = LabelTitleFolder(myText : "THÈMES")
    
    var addButton : UIButton = {
        var button = UIButton(type: .custom)
        button.setTitle("+", for: .normal)
        button.backgroundColor = UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: -1, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
/*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup back ground color
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = "Plugs"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "LogoutButton"), style: .plain, target: self, action: #selector(handleLogout))
        view.addSubview(themeLabel)
        view.addSubview(themeTableView)
        view.addSubview(addButton)
        setupTableView()
        setupThemeLabel()
        setupAddButton()
    }
    
/*---------------------------------- FUNCTIONS BACKEND ------------------------------------------*/
    
/*---------------------------------- PROTOCOLS FUNCTIONS ------------------------------------------*/
    
    func sendString(text: String) {
        theme.append(text)
        let indexPath = IndexPath(row: theme.count - 1, section: 0)
        timerAdd = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(insertRow), userInfo: indexPath, repeats: false)
    }
    
/*------------------------------------- HANDLE BUTTONS --------------------------------------------*/
    
    func handleLogout () {
        present(ConnectionController(), animated: true, completion: nil)
    }
    
    func handleButton(){
        let controller = addThemeController()
        controller.delegate = self
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
/*---------------------------------- TABLE VIEW DATA SOURCE ----------------------------------------*/
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.theme.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ThemeCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)! as! ThemeCell
        cell.labelMatiere.text = self.theme[indexPath.row]
        if (indexPath.row % 2 == 0) {
            cell.viewInContentView.backgroundColor =  UIColor(r: 75, g: 214, b: 199)
            cell.labelMatiere.textColor = .white
        }else {
            cell.backgroundColor = .white
        }
        return cell
        
    }
    func insertRow(timer : Timer) {
        themeTableView.insertRows(at: [timer.userInfo as! IndexPath], with: .automatic)
    }
    
/*---------------------------------- TABLE VIEW DELEGATE ----------------------------------------*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SectionsController()
        controller.theme = theme[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
/*------------------------------------ CONSTRAINT --------------------------------------------------*/
    func setupTableView() {
        themeTableView.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 20).isActive = true
        themeTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        themeTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        themeTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        themeTableView.register(ThemeCell.self, forCellReuseIdentifier: reuseIdentifier)
        themeTableView.separatorStyle = .none
    }
    func setupThemeLabel() {
        themeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        themeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        themeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        themeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func setupAddButton() {
        addButton.leftAnchor.constraint(equalTo: themeLabel.rightAnchor, constant: 0).isActive = true
        addButton.lastBaselineAnchor.constraint(equalTo: themeLabel.lastBaselineAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    }
    
}
