//
//  HomeController.swift
//  Notee
//
//  Created by Mathis Delaunay on 14/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController,UITableViewDataSource,UITableViewDelegate, AddingDisciplineDelegate, LogoutUserDelegate {

/*------------------------------------ CONSTANTS ---------------------------------------------*/
    
    let reuseIdentifier = "cellDiscipline"
    
/*------------------------------------ VARIABLES ---------------------------------------------*/

    var discipline : [String] = []
    var timerAdd : Timer?
    var isConnected = false
    var refreshControl = UIRefreshControl()
    
    lazy var disciplineTableView : UITableView = {
        var tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.isHidden = true
        tv.refreshControl = self.refreshControl
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var noDiscipline : UILabel = {
        let label = UILabel()
        label.text = "Aucune matière"
        label.font = UIFont(name: "Helvetica", size: 20)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 86, g: 90, b: 97)
        label.textAlignment = .center
        return label
    }()
    
    let activityIndicor : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor(r: 86, g: 90, b: 98)
        return indicator
    }()
    
/*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup back ground color
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = "Matières"
        self.refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "LogoutButton"), style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "PlusButton"), style: .plain, target: self, action: #selector(handlePlus))
        view.addSubview(disciplineTableView)
        setupTableView()
        setupIndicator()
        loadDiscipline()
        checkIfUserConnected()
    }
    
/*---------------------------------- FUNCTIONS BACKEND ------------------------------------------*/
    
    func refreshPage() {
        setupIndicator()
        loadDiscipline()
    }
    
    func handleRefresh() {
        self.discipline.removeAll()
        self.noDiscipline.isHidden = true
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref  = Database.database().reference().child("members-discipline")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(uid){
                ref.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    guard let values = snapshot.value as? NSDictionary else {
                        return
                    }
                    for value in values {
                        if let key = value.key as? String {
                            self.discipline.append(key)
                        }
                    }
                    self.disciplineTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }) { (error) in
                    print(error.localizedDescription)
                }
            }else{
                self.refreshControl.endRefreshing()
                self.noDiscipline.isHidden = false
            }
        })
        
    }
    
    func loadDiscipline() {
        self.discipline.removeAll()
        self.noDiscipline.isHidden = true
        self.activityIndicor.startAnimating()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref  = Database.database().reference().child("members-discipline")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(uid){
                ref.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    guard let values = snapshot.value as? NSDictionary else {
                        return
                    }
                    for value in values {
                        if let key = value.key as? String {
                            self.discipline.append(key)
                        }
                    }
                    self.disciplineTableView.reloadData()
                    self.appearTableView()
                }) { (error) in
                    print(error.localizedDescription)
                }
            }else{
                self.appearTableView()
                self.noDiscipline.isHidden = false
            }
        })
    }
    
    func appearTableView() {
        self.disciplineTableView.isHidden = false
        self.activityIndicor.removeFromSuperview()
    }
    
    func checkIfUserConnected() {
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }
    }
    
/*---------------------------------- PROTOCOLS FUNCTIONS ------------------------------------------*/
    
    func sendString(disciplineName: String) {
        addNewDiscipline(disciplineName: disciplineName)
    }
    func addNewDiscipline(disciplineName: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref  = Database.database().reference().child("members-discipline").child(uid)
        let value = [disciplineName : true]
        ref.updateChildValues(value) { (error, refDatabase) in
            if error != nil {
                print(error!)
                return
            }
            self.discipline.append(disciplineName)
            let indexPath = IndexPath(row: self.discipline.count - 1, section: 0)
            self.timerAdd = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.insertRow), userInfo: indexPath, repeats: false)
        }
    }
    
    
/*------------------------------------- HANDLE BUTTONS --------------------------------------------*/
    
    func handleLogout () {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        discipline.removeAll()
        self.disciplineTableView.reloadData()
        let controller = ConnectionController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    func handlePlus(){
        let controller = addDisciplineController()
        controller.delegate = self
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
/*---------------------------------- TABLE VIEW DATA SOURCE ----------------------------------------*/
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discipline.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ThemeCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)! as! ThemeCell
        cell.labelMatiere.text = self.discipline[indexPath.row]
        if (indexPath.row % 2 == 0) {
            cell.viewInContentView.backgroundColor =  UIColor(r: 75, g: 214, b: 199)
            cell.labelMatiere.textColor = .white
        }else {
            cell.backgroundColor = .white
        }
        return cell
        
    }
    func insertRow(timer : Timer) {
        disciplineTableView.insertRows(at: [timer.userInfo as! IndexPath], with: .automatic)
    }
    
/*---------------------------------- TABLE VIEW DELEGATE ----------------------------------------*/

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ThemeController()
        controller.discipline = discipline[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
/*------------------------------------ CONSTRAINT --------------------------------------------------*/
    
    func setupIndicator() {
        self.view.addSubview(activityIndicor)
        activityIndicor.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicor.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicor.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicor.heightAnchor.constraint(equalToConstant: 40).isActive =  true
        
        activityIndicor.startAnimating()
        
        self.view.addSubview(noDiscipline)
        noDiscipline.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noDiscipline.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
        noDiscipline.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        noDiscipline.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupTableView() {
        disciplineTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        disciplineTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        disciplineTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        disciplineTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        disciplineTableView.register(ThemeCell.self, forCellReuseIdentifier: reuseIdentifier)
        disciplineTableView.separatorStyle = .none
    }
    
}
