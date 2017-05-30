//
//  PlugsController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class PlugsController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddingPlugDelegate {

/*------------------------------------ CONSTANTS ---------------------------------------------*/

    let cellId = "plugCell"
    
/*--------------------------------------- VARIABLES ---------------------------------------------*/
    
    var section : String?
    var onePlug : Plug = Plug()
    var twoPlug : Plug = Plug()
    var plugs : [Plug] = []
    var timerAdd : Timer?
    
    
    lazy var plugsTableView : UITableView = {
        var tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var plugsLabel : UILabel = LabelTitleFolder(myText : "PLUGS")
    
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
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = section
        
        //FOR TEST
        addButton.isEnabled = false
        plugs.append(onePlug)
        plugs.append(twoPlug)
        
        //Setting the back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "BackButton"), style: .plain, target: self, action: #selector(handleBack))
        
        view.addSubview(addButton)
        view.addSubview(plugsLabel)
        view.addSubview(plugsTableView)
        setupPlugsTableView()
        setupPlugsLabel()
        setupAddButton()
    }

/*---------------------------------- PROTOCOLS FUNCTIONS ------------------------------------------*/
    
    //Function of protocol addingProtocole
    func sendPlug(plug : Plug){
        plugs.append(plug)
        let indexPath = IndexPath(row: plugs.count - 1, section: 0)
        timerAdd = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(insertRow), userInfo: indexPath, repeats: false)
    }
    
    
/*------------------------------------- HANDLE BUTTONS --------------------------------------------*/

    func handleBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func handleAddButton() {
        let controller = addPlugController()
        controller.delegate = self
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
/*---------------------------------- TABLE VIEW DATA SOURCE ----------------------------------------*/

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlugsCell = plugsTableView.dequeueReusableCell(withIdentifier: cellId) as! PlugsCell
        if (indexPath.row % 2 == 0){
            cell.plugView.backgroundColor = UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
            cell.sujetLabel.textColor = .white
            cell.descriptionTextView.textColor = .white
        }
        return cell
    }
    func insertRow(timer : Timer) {
        plugsTableView.insertRows(at: [timer.userInfo as! IndexPath], with: .automatic)
    }

/*---------------------------------- TABLE VIEW DELEGATE ----------------------------------------*/

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = viewerController()
        let navController = UINavigationController(rootViewController: controller)
        let myModalStyleTransition = UIModalTransitionStyle.flipHorizontal
        navController.modalTransitionStyle = myModalStyleTransition
        present(navController, animated: true, completion: nil)
    }
    
/*------------------------------------ CONSTRAINT --------------------------------------------------*/
    
    func setupPlugsTableView() {
        plugsTableView.topAnchor.constraint(equalTo: plugsLabel.bottomAnchor, constant: 20).isActive = true
        plugsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        plugsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plugsTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        plugsTableView.register(PlugsCell.self, forCellReuseIdentifier: cellId)
        plugsTableView.separatorStyle = .none
    }
    
    func setupAddButton() {
        addButton.lastBaselineAnchor.constraint(equalTo: plugsLabel.lastBaselineAnchor).isActive = true
        addButton.leftAnchor.constraint(equalTo: plugsLabel.rightAnchor , constant: 0).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
    }
    
    func setupPlugsLabel() {
        plugsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        plugsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plugsLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        plugsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
