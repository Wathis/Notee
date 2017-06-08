////
////  SectionsController.swift
////  Notee
////
////  Created by Mathis Delaunay on 15/03/2017.
////  Copyright © 2017 Wathis. All rights reserved.
////
//
//import UIKit
//
//class SectionsController: UIViewController, UITableViewDataSource,UITableViewDelegate,AddingSectionThemeDelegate {
//    
//    /*------------------------------------ CONSTANTS ---------------------------------------------*/
//    
//    let reuseIdentifier = "cellSections"
//    
//    /*------------------------------------ VARIABLES ---------------------------------------------*/
//    
//    var section : [String] = ["La première guerre","La seconde guerre M","Anglais"]
//    var timerAdd : Timer?
//    var theme : String?
//    
//    
//    lazy var sectionTableView : UITableView = {
//        var tv = UITableView()
//        tv.delegate = self
//        tv.dataSource = self
//        tv.backgroundColor = .clear
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        return tv
//    }()
//    
//    var sectionLabel : UILabel = LabelTitleFolder(myText : "SECTIONS")
//    
//    var addButton : UIButton = {
//        var button = UIButton(type: .custom)
//        button.setTitle("+", for: .normal)
//        button.backgroundColor = UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
//        button.layer.masksToBounds = false
//        button.layer.cornerRadius = 15
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOffset = CGSize(width: -1, height: 1)
//        button.layer.shadowOpacity = 0.2
//        button.layer.shadowRadius = 1
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
//        //Set title avec the nav bar
//        self.navigationItem.title = theme
//        
//        //Setting the back button
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "BackButton"), style: .plain, target: self, action: #selector(handleBack))
//        
//        view.addSubview(sectionLabel)
//        view.addSubview(sectionTableView)
//        view.addSubview(addButton)
//        setupTableView()
//        setupsectionLabel()
//        setupAddButton()
//    }
//    
//    /*---------------------------------- PROTOCOLS FUNCTIONS ------------------------------------------*/
//    //Function of protocol addingProtocole
//    func sendString(text : String){
//        section.append(text)
//        let indexPath = IndexPath(row: section.count - 1, section: 0)
//        timerAdd = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(insertRow), userInfo: indexPath, repeats: false)
//    }
//    
//    /*------------------------------------- HANDLE BUTTONS --------------------------------------------*/
//    
//    func handleAddButton() {
//        let controller = addThemeController()
//        controller.delegate = self
//        let navController = UINavigationController(rootViewController: controller)
//        present(navController, animated: true, completion: nil)
//    }
//    
//    func handleBack() {
//        _ = self.navigationController?.popViewController(animated: true)
//    }
//    
//    /*---------------------------------- TABLE VIEW DATA SOURCE ----------------------------------------*/
//    
//    //NUMBER OF ROWS
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.section.count
//    }
//    //SIZE
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//    
//    //CELL GESTION
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell:SectionsCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)! as! SectionsCell
//        cell.labelSection.text = self.section[indexPath.row]
//        if (indexPath.row % 2 == 0) {
//            cell.viewInContentView.backgroundColor =  UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
//            cell.labelSection.textColor = .white
//        }else {
//            cell.backgroundColor = .white
//        }
//        return cell
//        
//    }
//    func insertRow(timer : Timer) {
//        sectionTableView.insertRows(at: [timer.userInfo as! IndexPath], with: .automatic)
//    }
//    
//    /*---------------------------------- TABLE VIEW DELEGATE ----------------------------------------*/
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = PlugsController()
//        controller.section = section[indexPath.row]
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
//    
//    
//    /*------------------------------------ CONSTRAINT --------------------------------------------------*/
//    
//    func setupAddButton() {
//        addButton.lastBaselineAnchor.constraint(equalTo: sectionLabel.lastBaselineAnchor).isActive = true
//        addButton.leftAnchor.constraint(equalTo: sectionLabel.rightAnchor , constant: 0).isActive = true
//        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        addButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
//    }
//    func setupTableView() {
//        sectionTableView.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 20).isActive = true
//        sectionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
//        sectionTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        sectionTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
//        sectionTableView.register(SectionsCell.self, forCellReuseIdentifier: reuseIdentifier)
//        sectionTableView.separatorStyle = .none
//    }
//    func setupsectionLabel() {
//        sectionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
//        sectionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        sectionLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        sectionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//    }
//}
